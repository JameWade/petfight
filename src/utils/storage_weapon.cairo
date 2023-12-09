use starknet::{
  Store,
  storage_address_from_base_and_offset,
  storage_read_syscall,
  storage_write_syscall,
  SyscallResult,
  StorageBaseAddress,
};
use petfight::structs::weapon::Weapon;
impl StoreWeaponArray of Store<Array<Weapon>>{
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<Array<Weapon>> {
        StoreWeaponArray::read_at_offset(address_domain, base, 0)
    }
    fn write(
        address_domain: u32, base: StorageBaseAddress, value: Array<Weapon>
    ) -> SyscallResult<()> {
        StoreWeaponArray::write_at_offset(address_domain, base, 0, value)
    }
      fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8
    ) -> SyscallResult<Array<Weapon>> {
        let mut arr: Array<Weapon> = ArrayTrait::new();
        // Read the stored array's length. If the length is superior to 255, the read will fail.
        let len: u8 = Store::<u8>::read_at_offset(address_domain, base, offset)
            .expect('Storage Span too large');
        offset += 1;
        // Sequentially read all stored elements and append them to the array.
        let exit = len + offset;
        loop {
            if offset >= exit {
                break;
            }
            let value = Store::<Weapon>::read_at_offset(address_domain, base, offset).unwrap();
            arr.append(value);
            offset += Store::<Weapon>::size();
        };
        // Return the array.
        Result::Ok(arr)
    }
fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8, mut value: Array<Weapon>
    ) -> SyscallResult<()> {
        // // Store the length of the array in the first storage slot.
        let len: u8 = value.len().try_into().expect('Storage - Span too large');
        Store::<u8>::write_at_offset(address_domain, base, offset, len);
        offset += 1;

        // Store the array elements sequentially
        loop {
            match value.pop_front() {
                Option::Some(element) => {
                    Store::<Weapon>::write_at_offset(address_domain, base, offset, element);
                    offset += Store::<Weapon>::size();
                },
                Option::None(_) => {
                    break Result::Ok(());
                }
            };
        }
    }

    fn size() -> u8 {
        255 * Store::<Weapon>::size()
    }
}