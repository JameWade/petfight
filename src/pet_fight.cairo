use petfight::pet_duck::PetDuck;
use starknet::ContractAddress;
use petfight::pet_user::User;
#[Starknet::interface]
trait IPet<TContractState> {
    fn fight(ref self: TContractState,rival_address: ContractAddress ) ;
}

#[starknet::contract]
mod PetFight{
    use petfight::pet_duck::PetDuck;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use array::ArrayTrait;
    #[storage]
    struct Storage{
        users: Array<ContractAddress>,   //用户列表
        pet:PetDuck,
        victor: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.users.write(ArrayTrait::<ContractAddress>::new());

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
    // #[derive(Drop, starknet::Event)]
    // struct VoteCast {
    //     voter: ContractAddress,
    //     vote: u8,
    // }

    #[external(v0)]
    impl petImpl of super::IPet<ContractState>{
        fn fight(ref self: ContractState ,rival_address: ContractAddress) {
                let mut a:Array<ContractAddress> = ArrayTrait::new();
                let caller: ContractAddress = get_caller_address(); 
                a.append(caller);
                self.users.write(a);
        }
    }
}