use petfight::structs::weapon::Weapon;
#[starknet::interface]
trait IWeapon721<TCS> {
    fn getWeapon(self: @TCS) -> Weapon;
}
#[starknet::contract]
mod Weapon721 {
    use petfight::structs::weapon::Weapon;
    use petfight::erc::erc721::erc721 as erc721_comp;
    component!(path:erc721_comp,storage:erc721_storage,event: ERC721Event);
    #[storage]
    struct Storage {
        weapon: Weapon,
        #[substorage(v0)]
        erc721_storage: erc721_comp::Storage,
    }
    #[external(v0)]
    impl Weapon721Impl of super::IWeapon721<ContractState> {
        fn getWeapon(self: @ContractState) -> Weapon {
            self.weapon.read()
        }
    }
     #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC721Event: erc721_comp::Event,

    }
    #[abi(embed_v0)]
    impl ERC721Impl = erc721_comp::ERC721<ContractState>;
    impl ERC721Helper = erc721_comp::ERC721HelperImpl<ContractState>;

}
