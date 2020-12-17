require('dotenv').config()
const sha256 = require('js-sha256');

const salt = process.env.HASH_SALT
const pepper = process.env.HASH_PEPPER
const hashing_times = parseInt(process.env.HASH_TIMES)


module.exports = function (password){
    let hashed_password = password + salt + pepper;
    for (let i = 0; i < hashing_times; i++) {
        hashed_password = sha256(hashed_password);
    }
    return hashed_password;
};