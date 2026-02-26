using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebAssignment.Lee_Wei_Zhe.myClass
{
    public static class OtpHelper
    {
        public static string GenerateNumericOtp()
        {
            Random rnd = new Random();
            return rnd.Next(100000, 999999).ToString();
        }

        public static string HashOtp(string plainTextOtp)
        {
            return BCrypt.Net.BCrypt.HashPassword(plainTextOtp);
        }

        public static void SaveOtpToDb(string email, string otpHash, string purpose, DateTime expirationTime, string connString)
        {
            string query = @"INSERT INTO EmailOtp (Email, OtpHash, ExpiresAt, IsUsed, Purpose, CreatedAt) 
                             VALUES (@Email, @OtpHash, @ExpiresAt, 0, @Purpose, GETDATE())";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@OtpHash", otpHash);
                    cmd.Parameters.AddWithValue("@Purpose", purpose);
                    cmd.Parameters.AddWithValue("@ExpiresAt", expirationTime);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static void MarkOtpAsUsed(int otpId, string connString)
        {
            string updateQuery = "UPDATE EmailOtp SET IsUsed = 1 WHERE OtpId = @OtpId";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@OtpId", otpId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}