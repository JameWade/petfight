#[starknet::interface]
trait swordTrait<TContractState> {
    fn set_power(self: TContractState, power: u16);
    fn get_power(self: @TContractState);
    fn mint(self:@TContractState,token_id: u256);
}

#[starknet::component]
mod sword {
    #[storage]
    struct Storage {
        power:u16,
        mint_rank:u16     //达到16级才能铸造
        //todo add rank
    }

    #[embeddable_as(sword)]
    impl swordImpl<
        TContractState, 
        +HasComponent<TContractState>,
        impl ERC721:erc721_comp::HasComponent<TContractState>
    > of super::swordTrait<ComponentState<TContractState>> {
        fn get_power(self: TContractState, power: u16)  ->u16{
            self.power.read()
        }
        fn set_power(self: TContractState, power: u16){
            self.power.write(power);
        }
        
    }
}
