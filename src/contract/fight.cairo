use petfight::structs::pet_panda::petPanda;
use starknet::ContractAddress;
///这个合约主要是用来计算一些体力值、武器打造、判断用户是否有权力继续比赛等
//同时这个合约记录一份宠物经验作为用户排名   这个合约保存所有用户ContractAddress，从pet合约拿到对应宠物经验，在前端做排序
#[starknet::interface]
trait IPet<TState> {
    fn register(ref self: TState,contract_address: ContractAddress);
    fn get_players(self: @TState) -> Span<felt252>;
    fn fight(ref self: TState, rival_address: ContractAddress, contract_address: ContractAddress);
    fn get_ranks(self: @TState, addr: ContractAddress) -> petPanda;
}

#[starknet::contract]
mod fight {
    use core::traits::Into;
use core::starknet::event::EventEmitter;
    use petfight::contract::fight::IPet;
    use petfight::erc::mintable::MintTrait;
    use petfight::erc::erc20::erc20::ERC20HelperTrait;
    use petfight::ownerable::owner::TransferTrait;
    use array::{Span, ArrayTrait, SpanTrait, ArrayDrop, SpanSerde};
    use starknet::{ContractAddress, contract_address_to_felt252, get_caller_address};
    use petfight::utils::storage::StoreSpanFelt252;
    use petfight::ownerable::owner::owner as ownable_comp;
    use petfight::erc::erc20::erc20 as erc20_comp;
    use petfight::erc::mintable::mintable as mintable_comp;
    use petfight::contract::pet721::{IPetPanda721Dispatcher, IPetPanda721DispatcherTrait};
    use petfight::structs::pet_panda::{PetPandaTrait,petPanda};
    use super::super::event::FightEvent;
    component!(path: ownable_comp, storage: ownable_storage, event: OwnableEvent);
    component!(path: erc20_comp, storage: erc20_storage, event: ERC20Event);
    component!(path: mintable_comp, storage: mintable_storage, event: MintableEvent);
    #[storage]
    struct Storage {
        ranks: LegacyMap::<ContractAddress, petPanda>, //用户列表  address:rank
        players: Span<felt252>, //排名
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
        Transfer: FightEvent,
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
        self.mintable_storage.mint(recipient, initial_supply);
    }

    #[external(v0)]
    impl petImpl of super::IPet<ContractState> {
        fn fight(
            ref self: ContractState,
            rival_address: ContractAddress,
            contract_address: ContractAddress
        ) {
            let caller: ContractAddress = get_caller_address();
            let is_victory = IPetPanda721Dispatcher { contract_address }
                .fight(caller, rival_address);
            self.emit(FightEvent { from: caller, rival: rival_address, result: is_victory })
        }

        fn register(ref self: ContractState,contract_address: ContractAddress) {
            let caller: ContractAddress = get_caller_address();
            let pet: petPanda = IPetPanda721Dispatcher { contract_address }.mint(caller);
            self.ranks.write(caller, pet);
            let mut callers: Array<felt252> = ArrayTrait::new();
            callers.append(caller.into());
            self.players.write(callers.span());
        }
        fn get_players(self: @ContractState) -> Span<felt252> {
            return self.players.read();
        }
        fn get_ranks(self: @ContractState, addr: ContractAddress) -> petPanda {
            return self.ranks.read(addr);
        }
    }
}

