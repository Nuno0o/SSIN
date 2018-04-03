#include <stdio.h>
#include <openssl/bn.h>

#define NBITS 256

void printBN(char *msg,BIGNUM * a)
{
	char * number_str = BN_bn2hex(a);
	printf("%s %s\n",msg,number_str);
	OPENSSL_free(number_str);
}

int main()
{
	BN_CTX *ctx = BN_CTX_new();
	BIGNUM *p = BN_new();
	BIGNUM *q = BN_new();
	BIGNUM *n = BN_new();
	BIGNUM *e = BN_new();
	BIGNUM *M = BN_new();
	BIGNUM *d = BN_new();
	BIGNUM *c = BN_new();
	BIGNUM *res = BN_new();
	/*
	BN_generate_prime_ex(a,NBITS,1,NULL,NULL,NULL);
	BN_dec2bn(&b, "273489463796838501848592769467194369268");
	BN_rand(n,NBITS,0,0);

	BN_mul(res,a,b,ctx);
	printBN("a + b = ",res);

	BN_mod_exp(res,a,b,n,ctx);
	printBN("a^b mod n = ",res);
	*/
	BN_hex2bn(&n,"DCBFFE3E51F62E09CE7032E2677A78946A849DC4CDDE3A4D0CB81629242FB1A5");
	BN_dec2bn(&e,"65537");
	BN_hex2bn(&M,"4120746F702073656372657421");
	BN_hex2bn(&d,"74D806F9F3A62BAE331FFE3F0A68AFE35B3D2E4794148AACBC26AA381CD7D30D");

	BN_mod_exp(c,M,e,n,ctx);

	printBN("c = ",c);

	BN_mod_exp(res,c,d,n,ctx);

	printBN("d = ",res);

	return 0;
}
