
#[cfg(test)]
mod test {
    use core::array::SpanTrait;
use core::traits::Into;
use petfight::contract::fight::IPetDispatcherTrait;
use snforge_std::{declare, ContractClassTrait, start_warp, start_prank};
use petfight::contract::fight::IPetDispatcher;
use petfight::contract::fight::IPetDispatcherImpl;
use starknet::{contract_address_const, ContractAddress};
use debug::PrintTrait;
use petfight::pet_duck::{PetDuckTrait, PetDuck};
    #[test]
    #[available_gas(2000000)]
    fn call_and_invoke() {
        let contract = declare('PetFight');
        let caller_address: ContractAddress = 123.try_into().unwrap();
        let mut calldata = ArrayTrait::<felt252>::new();
        calldata.append(caller_address.into());
        let contract_address = contract.deploy(@calldata).unwrap();
    }
}
