use petfight::pet_duck::PetDuck;
use starknet::ContractAddress;
#[Starknet::interface]
trait IPet<TContractState> {
    fn fight(ref self: TContractState,rival_address: ContractAddress ) -> PetDuck;
}

#[starknet::contract]
mod PetFight{
    use petfight::pet_duck::PetDuck;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    #[storage]
    struct Storage{
        pet:PetDuck,
        victor: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        
    }

    // #[event]
    // #[derive(Drop, starknet::Event)]
    // enum Event {
    //     victor: Victor,
    // }

    // struct Victor {
    //     address: ContractAddress,
    // }
    /// @dev Represents a vote that was cast
    #[derive(Drop, starknet::Event)]
    struct VoteCast {
        voter: ContractAddress,
        vote: u8,
    }

    #[external(v0)]
    impl petImpl of super::IPet<ContractState>{
        fn fight(ref self: ContractState ,rival_address: ContractAddress) ->PetDuck{
                let caller: ContractAddress = get_caller_address(); 

        }
    }
}