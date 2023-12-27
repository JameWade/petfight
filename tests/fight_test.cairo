#[cfg(test)]
mod test {
    use array::{Span, ArrayTrait, SpanTrait, ArrayDrop, SpanSerde};
    use core::traits::TryInto;
    use core::traits::Into;
    use snforge_std::{
        declare, ContractClassTrait, start_warp, start_prank, CheatTarget, PrintTrait
    };
    use petfight::contract::game::{IGameDispatcher, IGameDispatcherImpl};
    use petfight::contract::pet721::{IPetPanda721Dispatcher, IPetPanda721DispatcherImpl};
    use starknet::{contract_address_const, ContractAddress, get_caller_address};
    fn deploy_contract(name: felt252, owner: ContractAddress) -> ContractAddress {
        let contract = declare(name);
        let args = array!['TEST', 'TE', 18, 5000, 0, owner.into(), owner.into()];
        let contractAddress = contract.deploy(@args).unwrap();
        contractAddress
    }

    #[test]
    fn test_fight() {
        let caller_address = get_caller_address();
        let owner = contract_address_const::<'ADMIN'>();
        let mut calldata = ArrayTrait::<felt252>::new();
        let contract_address = deploy_contract('game', owner);
        let game_dispatcher = IGameDispatcher { contract_address };
        ///PET721
        let contract = declare('PetPanda721');
        let arr = array![];
        let contractAddress: ContractAddress = contract.deploy(@arr).unwrap();
        let pet721_dispatcher = IPetPanda721Dispatcher { contract_address: contractAddress };
        start_prank(CheatTarget::One(contract_address), caller_address);
        game_dispatcher.register(contractAddress);
    // let ranks = dispatcher.get_ranks();
    // (*ranks.at(0)).print();

    //
    // let player = dispatcher.get_players(caller_address);
    // PetDuckTrait::get_blood(player).print();
    }
}
