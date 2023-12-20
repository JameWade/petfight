use petfight::structs::pet_panda::petPanda;
use starknet::ContractAddress;
//存储合约  只能获取状态？
#[starknet::interface]
trait IPetPanda721<TCS> {
    fn getPetPanda(self: @TCS, user_account: ContractAddress) -> petPanda;
    fn mint(ref self: TCS, user_account: ContractAddress) -> petPanda;
    fn updatePet(ref self: TCS, user: ContractAddress, pet: petPanda);
}
#[starknet::contract]
mod PetPanda721 {
    use petfight::ownerable::owner::owner::OwnableHelperTrait;
use petfight::ownerable::owner::TransferTrait;
use core::clone::Clone;
    use petfight::structs::pet_panda::PetPandaTrait;
    use petfight::contract::pet721::IPetPanda721;
    use starknet::{ContractAddress,get_caller_address};
    use petfight::structs::pet_panda::{petPanda, PetPandaImpl};
    use petfight::ownerable::owner::owner as ownable_comp;
    use petfight::erc::erc721::erc721 as erc721_comp;
    component!(path: ownable_comp, storage: ownable_storage, event: OwnableEvent);
    component!(path: erc721_comp, storage: erc721_storage, event: ERC721Event);
    #[storage]
    struct Storage {
        pet: LegacyMap<ContractAddress, petPanda>,
        #[substorage(v0)]
        ownable_storage: ownable_comp::Storage,
        #[substorage(v0)]
        erc721_storage: erc721_comp::Storage,
    }
    #[abi(embed_v0)]
    impl OwnerShipTransfer = ownable_comp::Transfer<ContractState>;
    impl OwnerShipHelper = ownable_comp::OwnableHelperImpl<ContractState>;
    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress,) {
        //一开始是部署的人，后面转移给game合约
        self.ownable_storage.init_ownable(owner);
    }

    #[external(v0)]
    impl PetPanda721Impl of super::IPetPanda721<ContractState> {
        fn getPetPanda(self: @ContractState, user_account: ContractAddress) -> petPanda {
            self.pet.read(user_account)
        }

        fn mint(ref self: ContractState, user_account: ContractAddress) -> petPanda {
            let pet = PetPandaImpl::new('pet1');
            self.pet.write(user_account, pet);
            pet
        }
        fn updatePet(ref self: ContractState, user: ContractAddress, pet: petPanda) {
            self.ownable_storage.validate_ownership();
            self.pet.write(user, pet);
        }
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnableEvent: ownable_comp::Event,
        ERC721Event: erc721_comp::Event,
    }
    #[abi(embed_v0)]
    impl ERC721Impl = erc721_comp::ERC721<ContractState>;
    impl ERC721Helper = erc721_comp::ERC721HelperImpl<ContractState>;
}

