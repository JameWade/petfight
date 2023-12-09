use petfight::pet_duck::PetDuck;
use starknet::ContractAddress;
#[starknet::interface]
trait IPet<TState> {
    fn register(ref self: TState);
    fn get_ranks(self: @TState) -> Span<felt252>;
    fn fight(ref self: TState, rival_address: ContractAddress);
    fn get_players(self: @TState, addr: ContractAddress) -> PetDuck;
}

#[starknet::contract]
mod fight {
    use petfight::erc::mintable::MintTrait;
use petfight::erc::erc20::erc20::ERC20HelperTrait;
    use petfight::ownerable::owner::TransferTrait;
    use array::{Span, ArrayTrait, SpanTrait, ArrayDrop, SpanSerde};
    use petfight::pet_duck::{PetDuckTrait, PetDuck};
    use starknet::{ContractAddress, contract_address_to_felt252, get_caller_address};
    use petfight::utils::storage::StoreSpanFelt252;
    use petfight::ownerable::owner::owner as ownable_comp;
    use petfight::erc::erc20::erc20 as erc20_comp;
    use petfight::erc::mintable::mintable as mintable_comp;
    component!(path: ownable_comp, storage: ownable_storage, event: OwnableEvent);
    component!(path: erc20_comp, storage: erc20_storage, event: ERC20Event);
    component!(path: mintable_comp, storage: mintable_storage, event: MintableEvent);
    #[storage]
    struct Storage {
        player: LegacyMap::<ContractAddress, PetDuck>, //用户列表  address:rank
        ranks: Span<felt252>, //排名
        #[substorage(v0)]
        ownable_storage: ownable_comp::Storage,
        #[substorage(v0)]
        erc20_storage: erc20_comp::Storage,
        #[substorage(v0)]
        mintable_storage: mintable_comp::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC20Event: erc20_comp::Event,
        OwnableEvent: ownable_comp::Event,
        MintableEvent: mintable_comp::Event,
    }

    #[abi(embed_v0)]
    impl OwnerShipTransfer = ownable_comp::Transfer<ContractState>;
    impl OwnerShipHelper = ownable_comp::OwnableHelperImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20Impl = erc20_comp::ERC20<ContractState>;
    impl ERC20Helper = erc20_comp::ERC20HelperImpl<ContractState>;

    #[abi(embed_v0)]
    impl MintImpl = mintable_comp::Mint<ContractState>;

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
        decimals: u8,
        initial_supply: u256,
        recipient: ContractAddress,
        owner: ContractAddress,
    ) {
        self.erc20_storage.init(name, symbol, decimals, initial_supply, recipient);
        self.ownable_storage.init_ownable(owner);
        self.mintable_storage.mint(recipient,initial_supply);
    }

    #[external(v0)]
    impl petImpl of super::IPet<ContractState> {
        fn fight(ref self: ContractState, rival_address: ContractAddress) {
            let caller: ContractAddress = get_caller_address();
        }
        fn register(ref self: ContractState) {
            let caller: ContractAddress = get_caller_address();
            let pet: PetDuck = PetDuckTrait::new();
            self.player.write(caller, pet);
            let mut callers: Array<felt252> = ArrayTrait::new();
            callers.append(contract_address_to_felt252(caller));
            let asd = callers.span();
            self.ranks.write(asd);
        }
        fn get_ranks(self: @ContractState) -> Span<felt252> {
            return self.ranks.read();
        }
        fn get_players(self: @ContractState, addr: ContractAddress) -> PetDuck {
            return self.player.read(addr);
        }
    }
}

