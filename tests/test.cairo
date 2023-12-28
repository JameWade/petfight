use core::traits::Into;
use core::debug::PrintTrait;
use core::integer::u16_sqrt;
#[test]
fn test_sqrt(){
    let num:u16 = 17;
    let res = u16_sqrt(num);
    assert(res == 5, res.into());
}