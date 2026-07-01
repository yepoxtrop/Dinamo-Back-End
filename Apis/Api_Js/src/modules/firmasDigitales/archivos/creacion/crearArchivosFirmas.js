/* Librerias */
import forge from "node-forge"; 

/* Modulos node js */
import path from "path";
import fs from "fs/promises"; 
import { Console } from "console";

export const creacionArchivosFirmas = async ({nombre_usuario, contrasena, rutaArchivoPub, rutaArchivoCrt, rutaArchivoP12}) => {
    try {
        /* PAR DE LLAVES(PUB, KEY) */
        /* creación de par de llaves */
        let clave = forge.pki.rsa.generateKeyPair({
            bits : 2048, 
            e : 0x10001
        }); 
        
        /* Convertir las llaves a PEM */
        let clavePrivadaPem = forge.pki.privateKeyToPem(clave.privateKey); 
        let clavePublicaPem = forge.pki.publicKeyToPem(clave.publicKey); 

        /* Guardar la llave pub */
        await fs.writeFile(
            rutaArchivoPub,
            clavePublicaPem,
            {
                encoding:'utf-8',
            }
        );
        
        /* CERTIFICADO (CRT) */
        let certificado = forge.pki.createCertificate();
        certificado.publicKey = clave.publicKey;

        /* Número de serie */
        const serialBytes = forge.random.getBytesSync(16);
        certificado.serialNumber = new forge.jsbn.BigInteger(serialBytes, 256).abs().toString(16);

        /* Fecha de validez */
        const fechaCreacion = new Date();
        certificado.validity.notBefore = fechaCreacion;
        certificado.validity.notAfter = new Date(fechaCreacion.getTime());
        certificado.validity.notAfter.setMonth(certificado.validity.notAfter.getMonth() + 3);

        /* Atributos del certificado */
        let atributosCertificado = [{
          name: 'commonName',
          value: nombre_usuario
        }, {
          name: 'countryName',
          value: 'CO'
        }, {
          name: 'stateOrProvinceName',
          value: 'Cundinamarca'
        }, {
          name: 'localityName',
          value: 'Bogota D.C'
        }, {
          name: 'organizationName',
          value: 'ACS - Aciel Soluciones Integrales S.A.S'
        }, {
          name: 'organizationalUnitName',
          value: 'Sistemas'
        }];

        /* Asignar sujeto e issuer (autofirmado) */
        certificado.setSubject(atributosCertificado);
        certificado.setIssuer(atributosCertificado);

        /* Extensiones del certificado */
        certificado.setExtensions([{
                name: 'basicConstraints',
                cA: true
            }, {
                name: 'keyUsage',
                keyCertSign: true,
                digitalSignature: true,
                nonRepudiation: true,
                keyEncipherment: true,
                dataEncipherment: true
            }, {
                name: 'extKeyUsage',
                serverAuth: true,
                clientAuth: true,
                codeSigning: true,
                emailProtection: true,
                timeStamping: true
            }, {
                name: 'nsCertType',
                client: true,
                server: true,
                email: true,
                objsign: true,
                sslCA: true,
                emailCA: true,
                objCA: true
            }, {
                name: 'subjectAltName',
                altNames: [{
                  type: 6, // URI
                  value: 'http://aciel.co'
                }, {
                  type: 7, // IP
                  ip: '172.16.8.1'
                }]
            }, {
                name: 'subjectKeyIdentifier'
            }
        ]);

        /* Firmar el certificado con la clave privada */
        certificado.sign(clave.privateKey, forge.md.sha256.create());

        /* Convertir el certificado a PEM */
        let certificadoPem = forge.pki.certificateToPem(certificado);

        /* Convertir certificado a X509 DER */
        let certificadoX509 = forge.pki.certificateToAsn1(certificado);

        /* Guardar el crt */
        await fs.writeFile(
            rutaArchivoCrt, 
            certificadoPem,
            {
                encoding:"utf-8"
            }
        );

        /* FIRMA DIGITAL (P12) */
        /* Iniciar la firma digital */
        let firmaDigital = forge.pkcs12.toPkcs12Asn1(
            clave.privateKey,
            certificado,
            contrasena,
            {
                generateLocalKeyId: true,
                friendlyName: 'Certificado ACS-FIRMAS'
            }
        );
        
        /* Convertir a binario(DER) */
        let firmaP12 = forge.asn1.toDer(firmaDigital).getBytes();

        /* Guardar el p12 */
        await fs.writeFile(
            rutaArchivoP12, 
            Buffer.from(firmaP12, 'binary')
        );        

        return {
            "llave_privada" : clavePrivadaPem,
            "fecha_creacion" : certificado.validity.notBefore,
            "fecha_vencimiento" : certificado.validity.notAfter
        };
    } catch (error) {
       return error; 
    }
}