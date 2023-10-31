#[starknet::contract]
mod petToken{
    //宠物乱斗中用于升级或者奖励等使用的token
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;

    #[storage]
    struct Storage{}

    #[constructor]
    fn constructor(ref self: ContractState,initial_supply:u256,recipient:ContractAddress) {
        let name = 'petToken';
        let symbol = 'PTK';
    }

}
