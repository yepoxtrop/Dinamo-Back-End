'use strict';

export function estadoObjetoNull(objeto){
    for (const propiedad in objeto) {
        if (objeto[propiedad] === null || objeto[propiedad] === undefined) {
            return false;
        }
    }
    return true;
}

export function estadoObjetoKeys(listaKeys, objeto){
    for (const llave of listaKeys) {
        if (!objeto.hasOwnProperty(llave)) {
            return false;
        }
    }
    return true;
}