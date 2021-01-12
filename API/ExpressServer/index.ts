const express = require('express');
var morgan = require('morgan');
const cors = require('cors');
import {pool_users, pool_plants} from "./imports/db";
const hash_sp_password = require("./imports/hashing");
import {User} from './Models/user'
import {Plant} from './Models/plant'
const app = express();

// App
app.use(morgan('dev'));
app.use(cors());
app.use(express.json());

// Usuario

app.post("/api/login",async(req,res) =>{
  const correo: string = req.body.correo;

  const contrasenna: string = hash_sp_password(req.body.contrasenna);

  const query: string = `select splogin(
    '${correo}' :: varchar,
    '${contrasenna}' :: varchar);`;

  pool_users.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].splogin === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})

app.post("/api/getUserInfo",async(req,res) =>{
  const correo: string = req.body.correo;

  const query: string = `select uid,nombre,correo,nombretipoOrganizacion,razon,admin from spGetUserInfo('${correo}');`;
  
  pool_users.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      res.status(200).send({"info":result.rows[0]});

    })
  })
})

app.post("/api/getid",async(req,res) =>{
  const uuid: string = req.body.uuid;

  const query: string = `SELECT spGetUserIdwithUUID('${uuid}') as id;`;
  
  pool_users.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack);
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack);
      }
      res.status(200).send(result.rows[0]);
    })
  })
})

app.post("/api/register_user",async(req,res) =>{

  const user: User = new User(req.body.nombre, req.body.correo, hash_sp_password(req.body.contrasenna), req.body.tipoOrganizacion,req.body.razon,req.body.admin);

  const query: string = `select spcrearusuario(
    '${user.nombre}' :: varchar,
    '${user.correo}' :: varchar,
    '${user.contrasenna}' :: varchar,
    '${user.tipoOrganizacion}' :: varchar,
    '${user.razon}' :: varchar,
    '${user.admin}':: boolean);`;

  pool_users.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spcrearusuario === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})


// Familia

app.get("/api/listFamilias",async(_req,res) =>{
  const query: string = 
  `
  SELECT nombre from spgetfamilias();
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send({"familias":result.rows});
    })
  })
})

app.post("/api/agregar_familia",async(req,res) =>{
  const familia: string = req.body.familia

  const query: string = `select spagregarfamilia(
    '${familia}' :: varchar);`;

  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spagregarfamilia === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})

// Fenologia
app.get("/api/listFenologias",async(_req,res) =>{
  const query: string = 
  `
  SELECT nombre from spgetfenologias();
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send({"fenologias":result.rows});
    })
  })
})

app.post("/api/agregar_fenologia",async(req,res) =>{
  const fenologia: string = req.body.fenologia

  const query: string = `select spagregarfenologia(
    '${fenologia}' :: varchar);`;

  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spagregarfenologia === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})


// Metodo de dispersion
app.get("/api/listMetodosDispersion",async(_req,res) =>{
  const query: string = 
  `
  SELECT nombre from spgetmetodosdispersion();
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send({"metodosdispersion":result.rows});
    })
  })
})

app.post("/api/agregar_metododispersion",async(req,res) =>{
  const metododispersion: string = req.body.metododispersion

  const query: string = `select spagregarmetododispersion(
    '${metododispersion}' :: varchar);`;

  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spagregarmetododispersion === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})

// Agente polinizador

app.get("/api/listAgentePolinizador",async(_req,res) =>{
  const query: string = 
  `
  SELECT nombre from spgetagentespolinizadores();
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send({"agentes":result.rows});
    })
  })
})

app.post("/api/agregar_agentepolinizador",async(req,res) =>{
  const agentepolinizador: string = req.body.agentepolinizador

  const query: string = `select spagregaragentepolinizador(
    '${agentepolinizador}' :: varchar);`;

  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spagregaragentepolinizador === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})


// Plantas

app.get("/api/ver_plantas/:filtro",async(req,res) =>{
  const filtro: string = req.params.filtro;

  const query: string = `select * from spverplantas('${filtro}')`;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }

      res.status(200).send(JSON.stringify(result.rows));
    })
  })
})

// REF: https://stackoverflow.com/questions/9229645/remove-duplicate-values-from-js-array
function uniqBy(a, key) {
  var seen = {};
  return a.filter(function(item) {
      var k = key(item);
      return seen.hasOwnProperty(k) ? false : (seen[k] = true);
  })
}

function get_plantas_filtros(index: number, max: number, filtros: string[], results, req, res){
  const query: string = `select * from spverplantas('${filtros[index]}')`;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.status(500).send({"ok": 0});
      return console.error('Error acquiring client', err.stack);
    } else{
      client.query(query, (err, result) => {
        release()
        if (err) {
          res.status(500).send({"ok": 0});
          return console.error('Error executing query', err.stack);
        }else{
          for (let i = 0; i < result.rows.length; i++) {
            const element = result.rows[i];
            results.push(element);
          }
          
          index = index + 1;
          if(index >= max) {
            results = uniqBy(results, JSON.stringify)
            results = {
              "ok": 1,
              "results": results
            }
            res.status(200).send(JSON.stringify(results));
          }
          else {
            get_plantas_filtros(index, max, filtros, results, req, res);
          }
        }   
      })
    }
  })
}

app.post("/api/ver_plantas/", async (req,res) =>{
  const filtros: string[] = req.body.filtros;

  get_plantas_filtros(0, filtros.length, filtros, [], req, res);
})

app.post("/api/agregar_planta",async(req,res) =>{
  const planta: Plant = new Plant(
    req.body.nombreComun,
    req.body.nombreCientifico,
    req.body.origen,
    parseInt(req.body.minRangoAltitudinal),
    parseInt(req.body.maxRangoAltitudinal),
    parseInt(req.body.metros),
    req.body.requerimientosDeLuz,
    req.body.habito, 
    req.body.familia, 
    req.body.fenologia, 
    req.body.agentePolinizador, 
    req.body.metodoDispersion, 
    req.body.frutos, 
    req.body.texturaFruto, 
    req.body.flor, 
    req.body.usosConocidos, 
    req.body.paisajeRecomendado,
    req.body.imagen);

  const query: string = `select spagregarplanta(
    '${planta.nombreComun}' :: varchar,
    '${planta.nombreCientifico}' :: varchar,
    '${planta.origen}' :: varchar,
    ${planta.minRangoAltitudinal},
    ${planta.maxRangoAltitudinal},
    ${planta.metros},
    '${planta.requerimientosDeLuz}' :: varchar,
    '${planta.habito}' :: varchar,
    '${planta.familia}' :: varchar,
    '${planta.fenologia}' :: varchar,
    '${planta.agentePolinizador}' :: varchar,
    '${planta.metodoDispersion}' :: varchar,
    '${planta.frutos}' :: varchar,
    '${planta.texturaFruto}' :: varchar,
    '${planta.flor}' :: varchar,
    '${planta.usosConocidos}' :: varchar,
    '${planta.paisajeRecomendado}' :: varchar);`;

  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spagregarplanta === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})

app.post("/api/getPlantasDeUsuario",async(req,res) =>{
  const id: string = req.body.id;

  const query: string = `SELECT 
                familia,
                fenologia,
                polinizador,
                metododispersion,
                nombrecomun,
                nombrecientifico,
                origen,
                minRangoaltitudinal,
                maxRangoaltitudinal,
                metros,
                requerimientosdeluz,
                habito,
                frutos,
                texturafruto,
                flor,
                usosconocidos,
                paisajerecomendado,
                imagen
                from spGetPlantasXUsuario(${id})`;

  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      res.status(200).send({"plantas":result.rows});
      
    })
  })
})

app.post("/api/modificar_planta",async(req,res) =>{
  const planta: Plant = new Plant(
    req.body.nombreComun,
    req.body.nombreCientifico,
    req.body.origen,
    parseInt(req.body.minRangoAltitudinal),
    parseInt(req.body.maxRangoAltitudinal),
    parseInt(req.body.metros),
    req.body.requerimientosDeLuz,
    req.body.habito, 
    req.body.familia, 
    req.body.fenologia, 
    req.body.agentePolinizador, 
    req.body.metodoDispersion, 
    req.body.frutos, 
    req.body.texturaFruto, 
    req.body.flor, 
    req.body.usosConocidos, 
    req.body.paisajeRecomendado,
    req.body.imagen);

  const query: string = `select spmodificarplanta(
    '${planta.nombreComun}',
    '${planta.nombreCientifico}',
    '${planta.origen}' ,
    ${planta.minRangoAltitudinal},
    ${planta.maxRangoAltitudinal},
    ${planta.metros},
    '${planta.requerimientosDeLuz}',
    '${planta.habito}',
    '${planta.familia}',
    '${planta.fenologia}',
    '${planta.agentePolinizador}',
    '${planta.metodoDispersion}',
    '${planta.frutos}',
    '${planta.texturaFruto}',
    '${planta.flor}',
    '${planta.usosConocidos}',
    '${planta.paisajeRecomendado}' );`;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      
      if(result.rows[0].spmodificarplanta === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })
})

app.post("/api/eliminar_planta",async(req,res) =>{
  
  const nombreComun = req.body.nombreComun;

  const query: string = 
  
  `select spEliminarPlanta('${nombreComun}') as success;`;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send(result.rows[0]);
    })
  })
})

// Viveros

app.post("/api/agregarVivero",async(req,res) =>{
  const nombre: string = req.body.nombreVivero;
  const direccion: string = req.body.direccion;
  const telefonos: string = req.body.telefonos;
  const horarios: string = req.body.horarios;

  const query: string = 
  `
  SELECT spAgregarVivero('${nombre}','${direccion}','${telefonos}','${horarios}') as success;
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send(result.rows[0]);
      
    })
  })
})

app.post("/api/getInfoVivero",async(req,res) =>{
  const nombreVivero: string = req.body.nombreVivero;

  const query: string = 
  `
  SELECT nombre, direccion, telefonos, horarios from spGetInfoVivero('${nombreVivero}');
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send({"info":result.rows[0]});
      
    })
  })
})

app.get("/api/listViveros",async(_req,res) =>{
  const query: string = 
  `
  SELECT nombre, direccion, telefonos, horarios FROM spListViveros();
  `;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      //res.status(200).send(result);
      res.status(200).send({"viveros":result.rows});
    })
  })
})

app.post("/api/actualizarInfoVivero",async(req,res) =>{
  
  const nombre = req.body.nombre;
  const direccion = req.body.direccion;
  const telefonos = req.body.telefonos;
  const horarios = req.body.horarios;

  const query: string = 
  
  `SELECT spModificarVivero('${nombre}','${direccion}','${telefonos}','${horarios}') as success;`;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send(result.rows[0]);
    })
  })
})

app.post("/api/eliminarVivero",async(req,res) =>{
  
  const nombre = req.body.nombre;

  const query: string = 
  
  `SELECT spEliminarVivero('${nombre}') as success;`;
  
  pool_plants.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }
      res.status(200).send(result.rows[0]);
    })
  })
})

// Execute

app.post("/api/update_user",async(req,res) =>{
  const jsonConf = {
    email: req.body.correo,
    nombre: req.body.nombre,
    TipoOrganizacion: req.body.tipoOrganizacion,
    uuid: req.body.uuid
  };

  const query: string = `select spUpdateUsuario(
    '${jsonConf.nombre}' :: varchar,
    '${jsonConf.email}' :: varchar,
    '${jsonConf.TipoOrganizacion}' :: varchar,
    '${jsonConf.uuid}' :: varchar);`;

  pool_users.connect((err, client, release) => {
    if (err) {
      res.sendStatus(500);
      return console.error('Error acquiring client', err.stack)
    }
    
    client.query(query, (err, result) => {
      release()
      if (err) {
        res.sendStatus(500);
        return console.error('Error executing query', err.stack)
      }

      if(result.rows[0].spupdateusuario === true) res.status(200).send({'ok': '1'});
      else res.status(200).send({'ok': '0'});
    })
  })

})

// Heroku, asigna puertos dinámicos
// Ref: https://stackoverflow.com/a/15693371

var port = 5000;
app.listen(process.env.PORT || port, () => console.log(`Api listening on port ${process.env.PORT || port}!`))