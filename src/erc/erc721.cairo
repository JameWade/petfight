use starknet::ContractAddress;
#[starknet::interface]
trait IERC721<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_token_uri(self: @TContractState, token_id: u256) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn set_approval_for_all(ref self: TContractState, operator: ContractAddress, approved: bool);
    fn approve(ref self: TContractState, to: ContractAddress, token_id: u256);
    fn safe_transfer_from(
        ref self: TContractState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    );
    // fn mint(ref self: TContractState, recipient: ContractAddress, token_id: u256);
}

#[starknet::component]
mod erc721 {
    use core::zeroable::Zeroable;
    use petfight::erc::erc721::IERC721;
    use starknet::{ContractAddress, get_caller_address};
    use super::super::erc721_receiver::{ERC721Receiver, ERC721ReceiverTrait};
    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        owners: LegacyMap<u256, ContractAddress>,
        balances: LegacyMap<ContractAddress, u256>,
        token_approvals: LegacyMap<u256, ContractAddress>,
        operator_approvals: LegacyMap<(ContractAddress, ContractAddress), bool>,
        token_uri: LegacyMap<u256, felt252>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: TransferEvent,
        Approval: ApprovalEvent,
        ApprovalForAll: ApprovalForAllEvent,
    }

    #[derive(Drop, starknet::Event)]
    struct TransferEvent {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        #[key]
        token_id: u256
    }
    #[derive(Drop, starknet::Event)]
    struct ApprovalEvent {
        #[key]
        owner: ContractAddress,
        #[key]
        approved: ContractAddress,
        #[key]
        token_id: u256
    }
    #[derive(Drop, starknet::Event)]
    struct ApprovalForAllEvent {
        #[key]
        owner: ContractAddress,
        #[key]
        operator: ContractAddress,
        approved: bool
    }
    mod Errors {
        const INVALID_TOKEN_ID: felt252 = 'ERC721: invalid token ID';
        const INVALID_ACCOUNT: felt252 = 'ERC721: invalid account';
        const UNAUTHORIZED: felt252 = 'ERC721: unauthorized caller';
        const APPROVAL_TO_OWNER: felt252 = 'ERC721: approval to owner';
        const SELF_APPROVAL: felt252 = 'ERC721: self approval';
        const INVALID_RECEIVER: felt252 = 'ERC721: invalid receiver';
        const ALREADY_MINTED: felt252 = 'ERC721: token already minted';
        const WRONG_SENDER: felt252 = 'ERC721: wrong sender';
        const SAFE_MINT_FAILED: felt252 = 'ERC721: safe mint failed';
        const SAFE_TRANSFER_FAILED: felt252 = 'ERC721: safe transfer failed';
    }

    #[embeddable_as(ERC721)]
    impl ERC721Impl<
        TContractState, +HasComponent<TContractState>
    > of super::IERC721<ComponentState<TContractState>> {
        fn get_token_uri(self: @ComponentState<TContractState>, token_id: u256) -> felt252 {
            assert(self._exists(token_id), Errors::INVALID_TOKEN_ID);
             self.token_uri.read(token_id)
        }
        fn get_name(self: @ComponentState<TContractState>) -> felt252 {
            self.name.read()
        }
        fn get_symbol(self: @ComponentState<TContractState>) -> felt252 {
            self.symbol.read()
        }
        //return account's nft number
        fn balance_of(self: @ComponentState<TContractState>, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), Errors::INVALID_ACCOUNT);
            self.balances.read(account)
        }
        /// Returns the owner address of `token_id`.
        fn owner_of(self: @ComponentState<TContractState>, token_id: u256) -> ContractAddress {
            self._owner_of(token_id)
        }

        fn safe_transfer_from(
            ref self: ComponentState<TContractState>,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            assert(
                self._is_approved_or_owner(get_caller_address(), token_id), Errors::UNAUTHORIZED
            );
            self._safe_transfer(from, to, token_id, data);
        }
        fn transfer_from(
            ref self: ComponentState<TContractState>,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256
        ) {
            assert(
                self._is_approved_or_owner(get_caller_address(), token_id), Errors::UNAUTHORIZED
            );
            self._transfer(from, to, token_id);
        }
         /// Change or reaffirm the approved address for an NFT.
        fn approve(ref self: ComponentState<TContractState>, to: ContractAddress, token_id: u256) {
            let owner = self._owner_of(token_id);

            let caller = get_caller_address();
            assert(
                owner == caller || self.is_approved_for_all(owner, caller), Errors::UNAUTHORIZED
            );
            self._approve(to, token_id);
        }
        
        //  Enable or disable approval for `operator` to manage all of the
         fn set_approval_for_all(
            ref self: ComponentState<TContractState>, operator: ContractAddress, approved: bool
        ) {
            self._set_approval_for_all(get_caller_address(), operator, approved)
        }
         /// Returns the address approved for `token_id`.
         fn get_approved(self: @ComponentState<TContractState>, token_id: u256) -> ContractAddress {
            assert(self._exists(token_id), Errors::INVALID_TOKEN_ID);
            self.token_approvals.read(token_id)
        }
         /// Query if `operator` is an authorized operator for `owner`.
        fn is_approved_for_all(
            self: @ComponentState<TContractState>, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self.operator_approvals.read((owner, operator))
        }
    }


    #[generate_trait]
    impl ERC721HelperImpl<
        TContractState, +HasComponent<TContractState>
    > of ERC721Trait<TContractState> {
        fn _owner_of(self: @ComponentState<TContractState>, token_id: u256) -> ContractAddress {
            let owner = self.owners.read(token_id);
            match owner.is_zero() {
                bool::False(()) => owner,
                bool::True(()) => panic_with_felt252(Errors::INVALID_TOKEN_ID)
            }
        }
        /// Returns whether `token_id` exists.
        fn _exists(self: @ComponentState<TContractState>, token_id: u256) -> bool {
            !self.owners.read(token_id).is_zero()
        }
        /// Returns whether `spender` is allowed to manage `token_id`.
        fn _is_approved_or_owner(
            self: @ComponentState<TContractState>, spender: ContractAddress, token_id: u256
        ) -> bool {
            let owner = self._owner_of(token_id);
            let is_approved_for_all = self.is_approved_for_all(owner, spender);
            owner == spender || is_approved_for_all || spender == self.get_approved(token_id)
        }
        /// Transfers ownership of `token_id` from `from` if `to` is either an account or `IERC721Receiver`.
        fn _safe_transfer(
            ref self: ComponentState<TContractState>,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            self._transfer(from, to, token_id);
            assert(
                _check_on_ERC721_received(from, to, token_id, data), Errors::SAFE_TRANSFER_FAILED
            );
        }
        /// Transfers `token_id` from `from` to `to`.
        fn _transfer(
            ref self: ComponentState<TContractState>,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256
        ) {
            assert(!to.is_zero(), Errors::INVALID_RECEIVER);
            let owner = self._owner_of(token_id);
            assert(from == owner, Errors::WRONG_SENDER);

            self.token_approvals.write(token_id, Zeroable::zero());
            self.balances.write(from, self.balances.read(to) + 1);
            self.balances.write(to, self.balances.read(from) - 1);
            self.owners.write(token_id, to);

            self.emit(TransferEvent { from, to, token_id });
        }
        /// Changes or reaffirms the approved address for an NFT.
         fn _approve(ref self: ComponentState<TContractState>, to: ContractAddress, token_id: u256) {
            let owner = self._owner_of(token_id);
            assert(owner != to, Errors::APPROVAL_TO_OWNER);

            self.token_approvals.write(token_id, to);
            self.emit(ApprovalEvent { owner, approved: to, token_id });
        }
         /// Enables or disables approval for `operator` to manage
        /// all of the `owner` assets.
        fn _set_approval_for_all( ref self: ComponentState<TContractState>,
            owner: ContractAddress,
            operator: ContractAddress,
            approved: bool){
             assert(owner != operator, Errors::SELF_APPROVAL);
             self.operator_approvals.write((owner,operator),approved);
             self.emit(ApprovalForAllEvent { owner, operator, approved });
        }
        /// Destroys `token_id`. The approval is cleared when the token is burned.
        fn _burn(ref self: ComponentState<TContractState>, token_id: u256) {
            let owner = self.owner_of(token_id);

            self.token_approvals.write(token_id, Zeroable::zero());
            self.balances.write(owner, self.balances.read(owner) - 1);
            self.owners.write(token_id, Zeroable::zero());
            self.emit(TransferEvent { from: owner, to: Zeroable::zero(), token_id });
        }
        fn init(ref self: ComponentState<TContractState>, name: felt252, symbol: felt252) {
            self.name.write(name);
            self.symbol.write(symbol);
        }
        /// Mints `token_id` and transfers it to `to`.
        fn _mint(ref self: ComponentState<TContractState>, to: ContractAddress, token_id: u256) {
            assert(!to.is_zero(), Errors::INVALID_RECEIVER);
            assert(!self._exists(token_id), Errors::ALREADY_MINTED);

            self.balances.write(to, self.balances.read(to) + 1);
            self.owners.write(token_id, to);

            self.emit(TransferEvent { from: Zeroable::zero(), to, token_id });
        }
        /// Mints `token_id` if `to` is either an account or `IERC721Receiver`.
        ///
        /// `data` is additional data, it has no specified format and it is sent in call to `to`.
        fn _safe_mint(
            ref self: ComponentState<TContractState>,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            self._mint(to, token_id);
            assert(
                _check_on_ERC721_received(Zeroable::zero(), to, token_id, data),
                Errors::SAFE_MINT_FAILED
            );
        }
        fn _set_token_uri(
            ref self: ComponentState<TContractState>, token_id: u256, token_uri: felt252
        ) {
            assert(self._exists(token_id), Errors::INVALID_TOKEN_ID);
            self.token_uri.write(token_id, token_uri)
        }
    }
    fn _check_on_ERC721_received(
        from: ContractAddress, to: ContractAddress, token_id: u256, _data: Span<felt252>
    ) -> bool {
        ERC721Receiver { contract_address: to }
            .on_erc721_received(get_caller_address(), from, token_id, _data);
        // todo
        true
    }
}
