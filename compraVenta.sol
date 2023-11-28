// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContratoCompraVenta {
    address public comprador;
    address public vendedor;
    uint public precio;
    bool public contratoFirmado;

    event ContratoFirmado(address comprador, address vendedor, uint precio);

    // Nueva estructura para representar un contrato
    struct Contrato {
        address comprador;
        address vendedor;
        uint precio;
        bool contratoFirmado;
    }

    // Mapping para almacenar contratos por dirección del comprador
    mapping(address => Contrato[]) public contratosPorComprador;

    // Mapping para almacenar contratos por dirección del vendedor
    mapping(address => Contrato[]) public contratosPorVendedor;

    modifier soloComprador() {
        require(msg.sender == comprador, "Solo el comprador puede llamar a esta funcion");
        _;
    }

    modifier contratoNoFirmado() {
        require(!contratoFirmado, "El contrato ya ha sido firmado");
        _;
    }

    constructor(address _comprador, uint _precio) {
        vendedor = msg.sender;
        comprador = _comprador;
        precio = _precio;

        // Registra el contrato en el mapping del comprador al momento de la creación
        contratosPorComprador[_comprador].push(Contrato({
            comprador: _comprador,
            vendedor: vendedor,
            precio: _precio,
            contratoFirmado: false
        }));
    }

    function firmarContrato() external soloComprador contratoNoFirmado {
        contratoFirmado = true;
        emit ContratoFirmado(comprador, vendedor, precio);

        // Actualiza el estado del contrato en el mapping del comprador al momento de la firma
        Contrato storage contratoComprador = contratosPorComprador[comprador][contratosPorComprador[comprador].length - 1];
        contratoComprador.contratoFirmado = true;

        // Registra el contrato en el mapping del vendedor al momento de la firma
        contratosPorVendedor[vendedor].push(Contrato({
            comprador: comprador,
            vendedor: vendedor,
            precio: precio,
            contratoFirmado: true
        }));
    }

    // Nueva función para obtener todos los contratos realizados por el vendedor
    function obtenerContratosPorVendedor() external view returns (Contrato[] memory) {
        return contratosPorVendedor[vendedor];
    }

    // Nueva función para obtener la cantidad de contratos realizados por el vendedor
    function cantidadContratosPorVendedor() external view returns (uint) {
        return contratosPorVendedor[vendedor].length;
    }

    // Nueva función para obtener todos los contratos realizados por el comprador
    function obtenerContratosPorComprador() external view returns (Contrato[] memory) {
        return contratosPorComprador[comprador];
    }
}
