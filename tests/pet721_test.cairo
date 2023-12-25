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
        test_address, declare, ContractClassTrait, start_warp, start_prank, CheatTarget, PrintTrait,
        cheatcodes::contract_class::RevertedTransaction,cheatcodes::contract_class::ContractClass
    };
    use starknet::{
        syscalls::deploy_syscall, contract_address_const, ContractAddress, get_caller_address,
        contract_address_try_from_felt252,class_hash::ClassHash
    };
    use petfight::structs::pet_panda::{petPanda, PetPandaImpl};
    fn deploy_contract(name: felt252,constructor_arguments:Array<felt252>) -> ContractAddress {
        let contract = declare(name);
        let contract_address = contract.deploy(@constructor_arguments).unwrap();
        contract_address
    }
    #[test]
    fn test_owner() {
        //设置owner
        let owner: ContractAddress = 123.try_into().unwrap();
        ///PET721
        let contract = declare('PetPanda721');
        let arr = array![owner.into()];
        let contract_address = contract.precalculate_address(@arr);
        start_prank(CheatTarget::One(contract_address), owner);
        let contract_address: ContractAddress =  deploy_contract('PetPanda721',arr);
        
    }

    #[test]
    fn test_mint(){
        let class_hash:ClassHash = 0x071ca4e36b3fcc96ac901d57ef62cc6527ba15b63e1414cf26e38731868f3cd5.try_into().unwrap();
        let contract =ContractClass{class_hash};
        // //设置owner
        let owner: ContractAddress = 123.try_into().unwrap();
        ///PET721
        let arr = array![owner.into()];
        let contract_address = contract.precalculate_address(@arr);
        start_prank(CheatTarget::One(contract_address), owner);
        let contract_address: ContractAddress =  deploy_contract('PetPanda721',arr);
        let dispatcher = IPetPanda721Dispatcher { contract_address };
        //user1  mint
        let user1: ContractAddress = 1.try_into().unwrap();
        let pet = dispatcher.mint(user1);
        //get user1
        let pet = dispatcher.getPetPanda(user1);
        pet.blood.print();
    }
}
