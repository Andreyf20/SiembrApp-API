export class User {
    nombre: string;
    correo: string;
    contrasenna: string;
    tipoOrganizacion: string;
    razon: string;

    constructor(nombre: string, correo: string, contrasenna: string, tipoOrganizacion: string, razon:string){
        this.nombre = nombre;
        this.correo = correo;
        this.contrasenna = contrasenna;
        this.tipoOrganizacion = tipoOrganizacion;
        this.razon = razon;
    }
}