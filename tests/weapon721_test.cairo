#[cfg(test)]
mod weapon721test {
    use petfight::contract::weapon721::IWeapon721DispatcherTrait;
use core::result::ResultTrait;
    use core::box::BoxTrait;
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use core::array::ArrayTrait;
    use petfight::structs::weapon::weapon;
    use core::traits::Into;
    use petfight::contract::weapon721::{IWeapon721Dispatcher,IWeapon721DispatcherImpl};
    use snforge_std::{
        test_address, declare, ContractClassTrait, start_warp, start_prank, stop_prank, CheatTarget,
        PrintTrait, cheatcodes::contract_class::RevertedTransaction,
        cheatcodes::contract_class::ContractClass
    };
    use starknet::{
        syscalls::deploy_syscall, contract_address_const, ContractAddress, get_caller_address,
        contract_address_try_from_felt252, class_hash::ClassHash
    };

    // #[test]
    fn deploy_contract()  ->ContractAddress{
        let contract = declare('Weapon721');
        let owner:ContractAddress = '123'.try_into().unwrap();
         let mut arr = array![owner.into()];
         let contract_address = contract.precalculate_address(@arr);
         start_prank(CheatTarget::One(contract_address), owner);    //由owner部署合约
        let contract_address:ContractAddress = contract.deploy(@arr).unwrap();
        stop_prank(CheatTarget::One(contract_address));
        contract_address
    }
    #[test]
    fn test_owner(){
        let contract_address = deploy_contract();
        let dispatcher = IWeapon721Dispatcher{contract_address};
         start_prank(CheatTarget::One(contract_address), '123'.try_into().unwrap());    
        dispatcher.Transfer_owner('1'.try_into().unwrap());
        stop_prank(CheatTarget::One(contract_address));
    }
}
