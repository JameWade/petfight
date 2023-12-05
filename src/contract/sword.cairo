 use starknet::ContractAddress;
#[starknet::interface]
trait swordTrait<TContractState> {
    fn set_power(ref self: TContractState, power: u16);
    fn get_power(self: @TContractState)  ->u16;
    fn mint(ref self:TContractState,to: ContractAddress,token_id: u256);
}

#[starknet::component]
mod sword {
    use petfight::erc::erc721::erc721::ERC721Trait;
use starknet::ContractAddress;
    use petfight::erc::erc721::erc721 as erc721_comp;
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
        +Drop<TContractState>,
        impl ERC721:erc721_comp::HasComponent<TContractState>
    > of super::swordTrait<ComponentState<TContractState>> {
        fn get_power(self: @ComponentState<TContractState>)  ->u16{
            self.power.read()
        }
        fn set_power(ref self: ComponentState<TContractState>, power: u16){
            self.power.write(power);
        }
        fn mint(ref self: ComponentState<TContractState>,to: ContractAddress,token_id: u256){
            let mut erc721_component = get_dep_component_mut!(ref self, ERC721);
            erc721_component._safe_mint(to, token_id,array![123,123].span());
        }
        
    }
}
