#[starknet::interface]
trait Iweapon{
    fn getWeapon() -> weapons;
}
mod weapon{

    #[storage]
    struct Storage{

    }
    struct  weapons{
    dao: u16,
    qiang:u16,
    jian:u16,
    ji:u16,
}
}
