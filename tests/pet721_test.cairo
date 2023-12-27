#[cfg(test)]
mod pet721test {
    use core::result::ResultTrait;
    use core::box::BoxTrait;
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use core::array::ArrayTrait;
    use petfight::structs::weapon::weapon;
    use petfight::contract::pet721::IPetPanda721DispatcherTrait;
    use core::traits::Into;
    use petfight::contract::pet721::IPetPanda721Dispatcher;
    use snforge_std::{
        test_address, declare, ContractClassTrait, start_warp, start_prank, stop_prank, CheatTarget,
        PrintTrait, cheatcodes::contract_class::RevertedTransaction,
        cheatcodes::contract_class::ContractClass
    };
    use starknet::{
        syscalls::deploy_syscall, contract_address_const, ContractAddress, get_caller_address,
        contract_address_try_from_felt252, class_hash::ClassHash
    };
    use petfight::structs::pet_panda::{petPanda, PetPandaImpl, PetPandaPrint};
    fn deploy_contract(name: felt252,) -> ContractAddress {
        //设置owner
        let owner: ContractAddress = 123.try_into().unwrap();
        ///PET721
        let contract = declare('PetPanda721');
        let arr = array![owner.into()];
         let contract_address = contract.precalculate_address(@arr);
         start_prank(CheatTarget::One(contract_address), owner);
        let contract_address = contract.deploy(@arr).unwrap();
        stop_prank(CheatTarget::One(contract_address));

        contract_address
    }
    // #[test]
    // fn test_owner() {
        
    // }

    #[test]
    fn test_mint() {
        // let class_hash: ClassHash =
        //     0x071ca4e36b3fcc96ac901d57ef62cc6527ba15b63e1414cf26e38731868f3cd5
        //     .try_into()
        //     .unwrap();
        // let contract = ContractClass { class_hash };
        // //设置owner
        let owner: ContractAddress = 123.try_into().unwrap();
        ///PET721
        let contract_address: ContractAddress = deploy_contract('PetPanda721');
        let dispatcher = IPetPanda721Dispatcher { contract_address };
        stop_prank(CheatTarget::One(contract_address));
        //user1  mint
        let user1: ContractAddress = 1.try_into().unwrap();
        start_prank(CheatTarget::One(contract_address), user1);
        let pet = dispatcher.mint(user1);
        //get user1
        let pet = dispatcher.getPetPanda(user1);
        pet.print();
        stop_prank(CheatTarget::One(contract_address));
    }

    #[test]
    fn test_update() {
        let contract_address: ContractAddress = deploy_contract('PetPanda721');
        let user1: ContractAddress = 1.try_into().unwrap();
        start_prank(CheatTarget::One(contract_address), user1);
        let dispatcher = IPetPanda721Dispatcher { contract_address };
        let pet = dispatcher.mint(user1);
        //update //must validate owner == game contractaddress
        // dispatcher.updatePet(user1, pet); //this will err
        stop_prank(CheatTarget::One(contract_address));
        let owner: ContractAddress = 123.try_into().unwrap();
        start_prank(CheatTarget::One(contract_address), owner);
        dispatcher.updatePet(user1, pet);
        stop_prank(CheatTarget::One(contract_address));
    }
}
