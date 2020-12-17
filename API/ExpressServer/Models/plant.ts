export class Plant {
    nombreComun: string;
    nombreCientifico: string;
    origen: string;
    minRangoAltitudinal: number;
    maxRangoAltitudinal: number;
    metros: number;
    requerimientosDeLuz: string;
    habito: string;
    familia: string;
    fenologia: string;
    agentePolinizador: string;
    metodoDispersion: string;
    frutos: string;
    texturaFruto: string;
    flor: string;
    usosConocidos: string;
    paisajeRecomendado: string;

    constructor(nombreComun: string, 
        nombreCientifico: string, 
        origen: string, 
        minRangoAltitudinal: number, 
        maxRangoAltitudinal: number, 
        metros: number, 
        requerimientosDeLuz: string, 
        habito: string, 
        familia: string,
        fenologia: string,
        agentePolinizador: string,
        metodoDispersion: string,
        frutos: string,
        texturaFruto: string,
        flor: string,
        usosConocidos: string,
        paisajeRecomendado: string){
            this.nombreComun = nombreComun;
            this.nombreCientifico = nombreCientifico;
            this.origen = origen;
            this.minRangoAltitudinal = minRangoAltitudinal;
            this.maxRangoAltitudinal = maxRangoAltitudinal;
            this.metros = metros;
            this.requerimientosDeLuz = requerimientosDeLuz;
            this.habito = habito;
            this.familia = familia;
            this.fenologia = fenologia;
            this.agentePolinizador = agentePolinizador;
            this.metodoDispersion = metodoDispersion;
            this.frutos = frutos;
            this.texturaFruto = texturaFruto;
            this.flor = flor;
            this.usosConocidos = usosConocidos;
            this.paisajeRecomendado = paisajeRecomendado;
    }
}