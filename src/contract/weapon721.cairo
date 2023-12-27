use petfight::structs::weapon::weapon;
use starknet::ContractAddress;
#[starknet::interface]
trait IWeapon721<TCS> {
    fn getWeapon(self: @TCS, user_account: ContractAddress) -> weapon;
    fn updateWeapon(ref self: TCS, user: ContractAddress, weapon: weapon);
    fn mint(ref self: TCS, user_account: ContractAddress) -> weapon;
    fn Transfer_owner(ref self: TCS, new_owner: ContractAddress);
}
#[starknet::contract]
mod Weapon721 {
    use petfight::ownerable::owner::TransferTrait;
    use petfight::structs::weapon::{weapon, WeaponImpl};
    use petfight::erc::erc721::erc721 as erc721_comp;
    use petfight::ownerable::owner::owner as ownable_comp;
    use starknet::ContractAddress;
    component!(path: ownable_comp, storage: ownable_storage, event: OwnableEvent);
    component!(path: erc721_comp, storage: erc721_storage, event: ERC721Event);
    impl OwnerShipTransfer = ownable_comp::Transfer<ContractState>;
    impl OwnerShipHelper = ownable_comp::OwnableHelperImpl<ContractState>;
    #[storage]
    struct Storage {
        weapons: LegacyMap<ContractAddress, weapon>,
        #[substorage(v0)]
        erc721_storage: erc721_comp::Storage,
        #[substorage(v0)]
        ownable_storage: ownable_comp::Storage,
    }
    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress,) {
        //一开始是部署的人，后面转移给game合约
        self.ownable_storage.init_ownable(owner);
    }
    #[external(v0)]
    impl Weapon721Impl of super::IWeapon721<ContractState> {
        fn getWeapon(self: @ContractState, user_account: ContractAddress) -> weapon {
            self.weapons.read(user_account)
        }
        fn updateWeapon(ref self: ContractState, user: ContractAddress, weapon: weapon) {
            self.ownable_storage.validate_ownership();
            self.weapons.write(user, weapon);
        }
        fn mint(ref self: ContractState, user_account: ContractAddress) -> weapon {
            let weapon = WeaponImpl::new('dao', 'dao');
            self.weapons.write(user_account, weapon);
            weapon
        }
        fn Transfer_owner(ref self: ContractState, new_owner: ContractAddress) {
            self.ownable_storage.transfer_ownership(new_owner);
        } 
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC721Event: erc721_comp::Event,
        OwnableEvent: ownable_comp::Event,
    }
    #[abi(embed_v0)]
    impl ERC721Impl = erc721_comp::ERC721<ContractState>;
    impl ERC721Helper = erc721_comp::ERC721HelperImpl<ContractState>;

}
