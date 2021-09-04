using System;
using System.Security.Cryptography;
using System.IO;
using System.Text;

namespace GameSeller.App_Code
{
    // reference:
    // https://k23-software.net/csharp-data-string-encryption-with-password-tutorial#full-source-code
    // https://k23-software.net/csharp-string-hashing-tutorial
    // https://stackoverflow.com/questions/43808411/cryptostream-why-cryptostreammode-write-to-encrypt-and-cryptostreammode-read-to
    // https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.cryptostream?view=net-5.0

    public static class Crypt
    {
        private static Rijndael _Rijndael;

        private static void CreateCryptor()
        {
            byte[] rfcSalt = new byte[] { 168, 180, 104, 141, 98, 203, 84, 227, 132, 39, 161, 0, 26, 49, 12, 76 };
            var rfc = new Rfc2898DeriveBytes("1C7015AB052B47D99192D21CD114ED31", rfcSalt);

            int keySize = 128; // options: 128, 192, 256
            _Rijndael = new RijndaelManaged
            {
                KeySize = keySize,
                Mode = CipherMode.CBC,
                Padding = PaddingMode.PKCS7,
                Key = rfc.GetBytes(keySize / 8),
                // IV = keySize / 8 = 16 bytes
                IV = new byte[] { 75, 3, 236, 226, 215, 188, 61, 200, 111, 249, 171, 65, 89, 23, 74, 107 }
            };
        }

        // param "text": string (UTF8)
        // return encrypted base64 string
        public static string Encrypt(string text)
        {
            if(_Rijndael == null)
            {
                CreateCryptor();
            }

            using(MemoryStream ms = new MemoryStream())
            {
                using(CryptoStream cs = new CryptoStream(ms, _Rijndael.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    using(StreamWriter sw = new StreamWriter(cs))
                    {
                        sw.Write(text); // perform encryption and write encrypted "text" into memory stream
                    }

                    // memory stream return encrypted byte[] and convert to base64 string
                    text = Convert.ToBase64String(ms.ToArray());
                }
            }

            return text;
        }

        // param "text": base64 string
        // return decrypted string (UTF8)
        public static string Decrypt(string text)
        {
            if(_Rijndael == null)
            {
                CreateCryptor();
            }

            // get byte[] of "text" and put in memory stream
            using(MemoryStream ms = new MemoryStream(Convert.FromBase64String(text)))
            {
                using(CryptoStream cs = new CryptoStream(ms, _Rijndael.CreateDecryptor(), CryptoStreamMode.Read))
                {
                    using (StreamReader sr = new StreamReader(cs))
                    {
                        text = sr.ReadToEnd(); // read content of memory stream and perform decryption
                    }
                }
            }

            return text;
        }


        // TODO: add salt
        public static string Hash(string text)
        {
            SHA512 sha = SHA512.Create();
            byte[] hash = sha.ComputeHash(Encoding.UTF8.GetBytes(text));

            StringBuilder sb = new StringBuilder();
            foreach(byte h in hash)
            {
                sb.Append(h.ToString("x2"));
            }

            return sb.ToString();
        }
    }
}