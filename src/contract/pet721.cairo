use petfight::structs::pet_panda::petPanda;
#[starknet::interface]
trait IPetPanda721<TCS> {
    fn getPetPanda(self: @TCS) -> petPanda;

}
#[starknet::contract]
mod PetPanda721 {
    use petfight::structs::pet_panda::{petPanda,PetPandaImpl};
    use petfight::erc::erc721::erc721 as erc721_comp;
    // component!(path:erc721_comp,storage:erc721_storage,event: ERC721Event);
    #[storage]
    struct Storage {
        pet: petPanda,
        // #[substorage(v0)]
        // erc721_storage: erc721_comp::Storage,
    }
    #[constructor]
    fn constructor(ref self: ContractState) {
        let pet = PetPandaImpl::new('pet1');
        self.pet.write(pet);
    }
    #[external(v0)]
    impl PetPanda721Impl of super::IPetPanda721<ContractState> {
        fn getPetPanda(self: @ContractState) -> petPanda {
            self.pet.read()
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
