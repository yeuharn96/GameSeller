using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace GameSeller.App_Code
{
    /**
     * Usage: 
     * Database.Connect()
     *          .Cmd()
     *          .AddCmdParam() [**optional]
     *          .AddCmdReturn() [**optional]
     *          .Exec() / .ExecReader() / .ExecScalar()
     *          .ReturnValue() [**optional]
     *          .Close()
     */

    public class Database
    {
        public enum ConnectionType { Read, Write };
        
        private static Database _db = null;

        public static Database Connect(ConnectionType type)
        {
            if (_db == null)
                _db = new Database(type);

            return _db;
        }

        public static DataTable Query(string sql, params string[] encryptColumns)
        {
            DataTable dt = new DataTable();
            Database.Connect(ConnectionType.Write)
                .Cmd(sql)
                .ExecReader(ref dt)
                .Close();

            return EncryptColumns(dt, encryptColumns);
        }

        public static DataTable EncryptColumns(DataTable dt, params string[] cols)
        {
            foreach(string col in cols)
            {
                string newCol = string.Format("_{0}", col);
                dt.Columns.Add(newCol, typeof(string));

                foreach(DataRow dr in dt.Rows)
                {
                    dr[newCol] = Crypt.Encrypt(dr[col].ToString());
                }

                dt.Columns.Remove(col);
                dt.Columns[newCol].ColumnName = col;
            }

            return dt;
        }

        private SqlConnection connection;
        private SqlCommand sqlCommand;
        private string returnParam;

        private Database(ConnectionType connectionType)
        {
            string conName = connectionType == ConnectionType.Read ? "con_read" : "con_write";
            string con = ConfigurationManager.ConnectionStrings[conName].ConnectionString;
            this.connection = new SqlConnection(con);
            this.connection.Open();
        }

        public Database Cmd(string cmd, bool isStoreProc = false)
        {
            this.sqlCommand = new SqlCommand(cmd, this.connection);
            this.sqlCommand.CommandType = isStoreProc ? CommandType.StoredProcedure : CommandType.Text;
            return this;
        }

        public Database AddCmdParam(string name, SqlDbType dbType, object value)
        {
            this.sqlCommand.Parameters.Add(name, dbType).Value = value;
            return this;
        }

        public Database AddCmdParam(params SqlParameter[] values)
        {
            this.sqlCommand.Parameters.AddRange(values);
            return this;
        }

        public Database AddCmdReturn(string name, SqlDbType dbType)
        {
            this.sqlCommand.Parameters.Add(name, dbType).Direction = ParameterDirection.ReturnValue;
            return this;
        }

        public Database ReturnValue(ref object obj)
        {
            obj = this.sqlCommand.Parameters[returnParam].Value;
            return this;
        }

        public Database ExecReader(ref DataTable dt)
        {
            if (dt == null)
                dt = new DataTable();
            dt.Load(this.sqlCommand.ExecuteReader());

            return this;
        }

        public Database ExecScalar(out object obj)
        {
            obj = this.sqlCommand.ExecuteScalar();
            return this;
        }

        public Database Exec()
        {
            this.sqlCommand.ExecuteNonQuery();
            return this;
        }

        public void Close()
        {
            if (this.connection != null)
                this.connection.Dispose();
            _db = null;
        }
    }
}