use core::{starknet::StorePacking, traits::{TryInto, Into}};
#[derive(Copy, Drop, Serde, starknet::Store)]
struct Weapon{
     name:felt252,
     symbol:felt252,
}

// impl ItemPrimitivePacking of StorePacking<Weapon, felt252> {
//     fn pack(value: Weapon) -> felt252 {
//      //    (value.name.into() + value.xp.into() * TWO_POW_7 + value.metadata.into() * TWO_POW_16)
//      //        .try_into()
//      //        .unwrap()
//      1
//     }

//     fn unpack(value: felt252) -> Weapon {
//      //    let packed = value.into();
//      //    let (packed, id) = integer::U256DivRem::div_rem(packed, TWO_POW_7.try_into().unwrap());
//      //    let (packed, xp) = integer::U256DivRem::div_rem(packed, TWO_POW_9.try_into().unwrap());
//      //    let (_, metadata) = integer::U256DivRem::div_rem(packed, TWO_POW_5.try_into().unwrap());

//      //    weapon {
//      //        id: id.try_into().unwrap(),
//      //        xp: xp.try_into().unwrap(),
//      //        metadata: metadata.try_into().unwrap()
//      //    }
//      Weapon{
//           name:1,
//           symbol:1,
//      }
//     }
// }