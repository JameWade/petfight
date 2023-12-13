use petfight::structs::pet_panda::petPanda;
use starknet::ContractAddress;
#[starknet::interface]
trait IPetPanda721<TCS> {
    fn getPetPanda(self: @TCS, user_account: ContractAddress) ->petPanda;
    fn mint(ref self: TCS, user_account: ContractAddress) ->petPanda ;
    fn fight(self: @TCS, caller: ContractAddress, rival_addr: ContractAddress) -> bool;
}
#[starknet::contract]
mod PetPanda721 {
    use petfight::structs::pet_panda::PetPandaTrait;
    use petfight::contract::pet721::IPetPanda721;
    use starknet::ContractAddress;
    use petfight::structs::pet_panda::{petPanda, PetPandaImpl};
    use petfight::erc::erc721::erc721 as erc721_comp;
    // component!(path: erc721_comp, storage: erc721_storage, event: ERC721Event);
    #[storage]
    struct Storage {
        pet: LegacyMap<ContractAddress, petPanda>,
        // #[substorage(v0)]
        // erc721_storage: erc721_comp::Storage,
    }


    #[external(v0)]
    impl PetPanda721Impl of super::IPetPanda721<ContractState> {
        fn getPetPanda(self: @ContractState, user_account: ContractAddress) -> petPanda {
            self.pet.read(user_account)
        }
        fn fight(
            self: @ContractState, caller: ContractAddress, rival_addr: ContractAddress
        ) -> bool {
            let mut self_panda = self.getPetPanda(caller);
            let mut rival_panda = self.getPetPanda(rival_addr);
            let is_victory = @self_panda.fight(@rival_panda);
            // if is_victory {
            //     //todo 修改经验
            //     self_panda.increase_rank(1, 1, 1, 1, 1, 1);
            //     rival_panda.increase_rank(0, 0, 0, 0, 0, 0);
            // } else {
            //     self_panda.increase_rank(1, 1, 1, 1, 1, 1);
            //     rival_panda.increase_rank(0, 0, 0, 0, 0, 0);
            // }
            // is_victory
            true
        }
        fn mint(ref self: ContractState, user_account: ContractAddress)->petPanda  {
            let pet = PetPandaImpl::new('pet1');
            self.pet.write(user_account, pet);
            pet
        }
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC721Event: erc721_comp::Event,
    }
// #[abi(embed_v0)]
// impl ERC721Impl = erc721_comp::ERC721<ContractState>;
// impl ERC721Helper = erc721_comp::ERC721HelperImpl<ContractState>;

}

