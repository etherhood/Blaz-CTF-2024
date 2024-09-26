from ecdsa import SigningKey, SECP256k1
from eth_account import Account
from eth_account.messages import encode_defunct, defunct_hash_message

message = encode_defunct(text="I♥SF")
mh = defunct_hash_message(text="I♥SF")

def encode_func(r, s, _):
    return f"0x{r:032x}", f"0x{s:032x}"

print(bytes.fromhex(f"{0x1337:064x}"))
# address = 0x71556C38F44e17EC21F355Bd18416155000BF5a6
sk = SigningKey.from_string(bytes.fromhex(f"{0x1337:064x}"), curve=SECP256k1)
print(sk)
out = sk.sign_digest(mh, sigencode=encode_func)
print("r, s", out)

vrs = (
	27,
	out[0],
	out[1],
)

print("v 0", Account.recover_message(message, vrs=vrs))

vrs = (
	28,
	out[0],
	out[1],
)

print("v 1", Account.recover_message(message, vrs=vrs))
