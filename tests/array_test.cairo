#[cfg(test)]
mod erc721test {
    use core::box::BoxTrait;
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use core::array::ArrayTrait;
    use petfight::structs::weapon::Weapon;
    use petfight::contract::pet721::IPetPanda721DispatcherTrait;
    use core::traits::Into;
    use petfight::contract::pet721::IPetPanda721Dispatcher;
    use snforge_std::{
        declare, ContractClassTrait, start_warp, start_prank, CheatTarget, PrintTrait
    };
    use petfight::contract::fight::{IPetDispatcher, IPetDispatcherImpl};
    use starknet::{contract_address_const, ContractAddress, get_caller_address};
    use petfight::structs::pet_panda::{petPanda, PetPandaImpl};
    fn deploy_contract(name: felt252) -> ContractAddress {
        let contract = declare(name);
        '123'.print();

        // let args = array!['TEST', 'TE', 18, 5000, 0, owner.into(), owner.into()];
        let args = array![];
        let contract_addr = contract.deploy(@args).unwrap();
        '123'.print();
        contract_addr
    }
    #[test]
    fn test_storage_skill() {
        let petPanda = PetPandaImpl::new('pet1');
        let contract_address = deploy_contract('PetPanda721');
        let pet = IPetPanda721Dispatcher { contract_address }.getPetPanda();
        pet.name.print();
        let weapon: Weapon = *pet.weapons.get(1).unwrap().unbox();
        weapon.name.print();
        weapon.name.print();
        weapon.name.print();
    }
}
