use petfight::pet_duck::PetDuck;
use starknet::ContractAddress;
#[starknet::interface]
trait IPet<TState> {
    fn register(ref self: TState);
    fn get_ranks(self: @TState)->Span<felt252>;
    fn fight(ref self: TState, rival_address: ContractAddress);
    fn get_players(self: @TState,addr :ContractAddress)  -> PetDuck;
}

#[starknet::contract]
mod PetFight {
    use petfight::ownerable::owner::TransferTrait;
use array::{ Span, ArrayTrait, SpanTrait, ArrayDrop, SpanSerde };
    use petfight::pet_duck::{PetDuckTrait,PetDuck};
    use starknet::{ContractAddress,contract_address_to_felt252,get_caller_address};
    use petfight::utils::storage::StoreSpanFelt252;
    use petfight::ownerable::owner::owner as ownable_comp;
    component!(path: ownable_comp, storage: ownable_storage, event: OwnableEvent);

    #[storage]
    struct Storage {
        player: LegacyMap::<ContractAddress, PetDuck>, //用户列表  address:rank
        ranks: Span<felt252>,                         //排名
        victor: ContractAddress,
        #[substorage(v0)]
        ownable_storage:ownable_comp::Storage,
    }

    #[event]
    #[derive(Drop,starknet::Event)]
    enum Event{
        OwnableEvent:ownable_comp::Event,
    }

    #[abi(embed_v0)]
    impl OwnerShipTransfer = ownable_comp::Transfer<ContractState>;
    impl OwnerShipHelper = ownable_comp::OwnableHelperImpl<ContractState>;
    #[constructor]
    fn constructor(ref self: ContractState,owner:ContractAddress) {
        self.ownable_storage.init_ownable(owner);
    }

    #[external(v0)]
    impl petImpl of super::IPet<ContractState> {
        fn fight(ref self: ContractState, rival_address: ContractAddress) {
            let caller: ContractAddress = get_caller_address();
        }
        fn register(ref self: ContractState) {
            let caller: ContractAddress = get_caller_address();
            let  pet :PetDuck = PetDuckTrait::new();
            self.player.write(caller, pet);
             let mut callers:Array<felt252> = ArrayTrait::new();
             callers.append(contract_address_to_felt252(caller));
             let asd = callers.span();
            self.ranks.write(asd);
        }
        fn get_ranks(self:@ContractState) ->Span<felt252> {
            return self.ranks.read();
        }
        fn get_players(self:@ContractState,addr:ContractAddress) -> PetDuck{
            return self.player.read(addr);
        }
    }
    
}



// #[cfg(test)]
// mod tests {
//     use core::array::SpanTrait;
//     use core::traits::Into;
//     use petfight::contract::fight::IPetDispatcherTrait;
//     use snforge_std::{declare, ContractClassTrait,start_warp,start_prank};
//     use super::IPetDispatcher;
//     use super::IPetDispatcherImpl;
//     use  starknet::{contract_address_const,ContractAddress,get_caller_address};
//     use debug::PrintTrait;
//      use petfight::pet_duck::{PetDuckTrait,PetDuck};
//      use array::{ Span, ArrayTrait, ArrayDrop, SpanSerde };
//     #[test]
//     fn call_and_invoke() {
//         let contract = declare('PetFight');
        
//         let caller_address: ContractAddress = 123.try_into().unwrap();
//         let  mut calldata = ArrayTrait::<felt252>::new();
//         calldata.append(caller_address.into());
//         let contract_address = contract.deploy(@calldata).unwrap();
//         let dispatcher = IPetDispatcher { contract_address };
//         start_prank(contract_address, caller_address);
//         dispatcher.register();
//         let  ranks = dispatcher.get_ranks();
//        (*ranks.at(0)).print();

//        //
//        let player = dispatcher.get_players(caller_address);
//        PetDuckTrait::get_blood(player).print();
//     }
// }
