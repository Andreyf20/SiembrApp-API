require('dotenv').config()
const Pool = require("pg").Pool;

export const pool_users = new Pool({
    user: process.env.POSTGRESQL_USER_USERS,
    password: process.env.POSTGRESQL_PASSWORD_USERS,
    database: process.env.POSTGRESQL_DATABASE_USERS,
    port: parseInt(process.env.POSTGRESQL_PORT_USERS),
    host: process.env.POSTGRESQL_HOST_USERS,
    ssl: { rejectUnauthorized: false }
});

export const pool_plants = new Pool({
    user: process.env.POSTGRESQL_USER_PLANTS,
    password: process.env.POSTGRESQL_PASSWORD_PLANTS,
    database: process.env.POSTGRESQL_DATABASE_PLANTS,
    port: parseInt(process.env.POSTGRESQL_PORT_PLANTS),
    host: process.env.POSTGRESQL_HOST_PLANTS,
    ssl: { rejectUnauthorized: false }
});

//Solution to: Error acquiring client Error: self signed certificate
// => https://stackoverflow.com/a/61125814

