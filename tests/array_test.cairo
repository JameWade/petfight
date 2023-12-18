// #[cfg(test)]
// mod erc721test {
//     use core::result::ResultTrait;
//     use core::box::BoxTrait;
//     use core::option::OptionTrait;
//     use core::traits::TryInto;
//     use core::array::ArrayTrait;
//     use petfight::structs::weapon::Weapon;
//     use petfight::contract::pet721::IPetPanda721DispatcherTrait;
//     use core::traits::Into;
//     use petfight::contract::pet721::IPetPanda721Dispatcher;
//     use snforge_std::{
//         test_address, declare, ContractClassTrait, start_warp, start_prank, CheatTarget, PrintTrait,
//         cheatcodes::contract_class::RevertedTransaction
//     };
//     use petfight::contract::game::{IGameDispatcher, IGameDispatcherImpl};
//     use starknet::{
//         syscalls::deploy_syscall, contract_address_const, ContractAddress, get_caller_address,
//         contract_address_try_from_felt252
//     };
//     use petfight::structs::pet_panda::{petPanda, PetPandaImpl};
//     fn deploy_contract(name: felt252) -> ContractAddress {
//         let contract = declare(name);
//         let constructor_arguments = @ArrayTrait::new();
//         // Precalculate the address to obtain the contract address before the constructor call (deploy) itself
//         let contract_address = contract.precalculate_address(constructor_arguments);
//         start_prank(CheatTarget::One(contract_address), 123.try_into().unwrap());

//         // let args = array!['TEST', 'TE', 18, 5000, 0, owner.into(), owner.into()];
//         let contract_addr = contract.deploy(constructor_arguments);
//         match contract_addr {
//             Result::Ok(value) => {
//                 value.print();
//                 // Result::<ContractAddress, RevertedTransaction>::Ok(value)
//                 value
//             },
//             Result::Err(e) => {
//                 '111'.print();
//                 e.panic_data.print();
//                 test_address()
//             },
//         }
//     }
//     #[test]
//     fn test_storage_skill() {
//         let petPanda = PetPandaImpl::new('pet1');
//         let contract_address = deploy_contract('PetPanda721');
//         // let pet = IPetPanda721Dispatcher { contract_address }.getPetPanda();   //没找到这个entry point
//         // pet.name.print();
//         // let weapon: Weapon = *pet.weapons.get(1).unwrap().unbox();
//         // weapon.name.print();
//         // weapon.name.print();
//         // weapon.name.print();
//     }
// }
