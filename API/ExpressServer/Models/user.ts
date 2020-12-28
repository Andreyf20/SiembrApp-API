export class User {
    nombre: string;
    correo: string;
    contrasenna: string;
    tipoOrganizacion: string;
    razon: string;
    admin: boolean;

    constructor(nombre: string, correo: string, contrasenna: string, tipoOrganizacion: string, razon:string,admin:boolean){
        this.nombre = nombre;
        this.correo = correo;
        this.contrasenna = contrasenna;
        this.tipoOrganizacion = tipoOrganizacion;
        this.razon = razon;
        this.admin = admin;
    }
}