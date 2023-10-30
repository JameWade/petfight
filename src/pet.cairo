#[Starknet::interface]
trait IPet<TContractState>{
    fn attack(ref self:TContractState,opponent: IPet);
    fn get_blood(self: @TContractState) ->felt252;
}

#[starknet::contract]
mod Pet{
    #[storage]
    struct storage{
        blood: u8,
        address: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.blood.write(100_u8);
        
    }

}