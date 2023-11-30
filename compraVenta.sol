// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContratoCompraVenta {
    address public vendedor;
    address public comprador;
    string public descripcion;
    uint public precio;
    bool public contratoFirmado;
    uint public numeroSecreto; 

    event ContratoCreado(address indexed vendedor, string descripcion, uint precio);
    event ContratoFirmado(address indexed comprador);

    modifier contratoNoFirmado() {
        require(!contratoFirmado, "El contrato ya ha sido firmado");
        _;
    }

    modifier soloVendedor() {
        require(msg.sender == vendedor, "Solo el vendedor puede llamar a esta funcion");
        _;
    }

    constructor() {

    }

    function inicializarContrato(string memory _descripcion, uint _precio, uint _numeroSecreto) external {
        require(!contratoFirmado, "El contrato ya ha sido firmado");

        descripcion = _descripcion;
        precio = _precio;
        vendedor = msg.sender;
        numeroSecreto = _numeroSecreto;

        emit ContratoCreado(vendedor, descripcion, precio);
    }

    function firmarContrato(uint _numeroSecreto) external contratoNoFirmado {
        require(_numeroSecreto == numeroSecreto, "Numero secreto incorrecto");

        comprador = msg.sender;
        contratoFirmado = true;

        emit ContratoFirmado(comprador);
    }

    function verDetalleContrato() external view returns (string memory, uint) {
        require(contratoFirmado, "El contrato aun no ha sido firmado");
        return (descripcion, precio);
    }
}
