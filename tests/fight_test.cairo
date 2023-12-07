#[cfg(test)]
mod test {
    use core::traits::TryInto;
use core::array::SpanTrait;
    use core::traits::Into;
    use petfight::contract::fight::IPetDispatcherTrait;
    use snforge_std::{declare, ContractClassTrait, start_warp, start_prank,CheatTarget,PrintTrait};
    use petfight::contract::fight::{IPetDispatcher,IPetDispatcherImpl};
    use starknet::{contract_address_const, ContractAddress,get_caller_address};
    // use debug::PrintTrait;
    use petfight::pet_duck::{PetDuckTrait, PetDuck};
    #[test]
    fn call_and_invoke() {
        let caller_address = get_caller_address();
        let owner = contract_address_const::<'ADMIN'>();
        let mut calldata = ArrayTrait::<felt252>::new();
        let contract_address =  deploy_contract('fight', owner);
        let dispatcher = IPetDispatcher { contract_address };
        start_prank(CheatTarget::One(contract_address), caller_address);
        dispatcher.register();
        let ranks = dispatcher.get_ranks();
        (*ranks.at(0)).print();

        //
        let player = dispatcher.get_players(caller_address);
        // PetDuckTrait::get_blood(player).print();
    }
    fn deploy_contract(name: felt252, owner: ContractAddress) ->ContractAddress{
        let contract = declare(name);
        let args = array!['TEST', 'TE', 18, 5000, 0, owner.into(), owner.into()];
        contract.deploy(@args).unwrap()
    }
     #[test]
    fn test_init() {
        let owner = contract_address_const::<'ADMIN'>();
        let contract_address = deploy_contract('fight', owner);
    }
}
