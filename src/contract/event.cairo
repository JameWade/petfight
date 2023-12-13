use starknet::ContractAddress;
#[event]
#[derive(Drop, starknet::Event)]
struct FightEvent {
    #[key]
    from: ContractAddress,
    #[key]
    rival: ContractAddress,
    #[key]
    result: bool,
}
