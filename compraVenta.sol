// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContratoCompraVenta {
    address public vendedor;
    address public comprador;
    string public descripcion;
    uint256 public precio;
    bool public contratoFirmado;
    uint256 public numeroSecreto;
    bool public contratoGuardado;

    event ContratoCreado(
        address indexed vendedor,
        string descripcion,
        uint256 precio
    );
    event ContratoFirmado(address indexed comprador);
    event ContratoGuardado();

    modifier contratoNoFirmado() {
        require(!contratoFirmado, "El contrato ya ha sido firmado");
        _;
    }

    modifier contratoFirmadoYNoGuardado() {
        require(
            contratoFirmado && !contratoGuardado,
            "El contrato no ha sido firmado o ya ha sido guardado"
        );
        _;
    }

    constructor() {
        // Constructor
    }

    function reiniciarContrato() external {
        require(msg.sender == vendedor, "Solo el vendedor puede reiniciar el contrato");
        vendedor = address(0);
        comprador = address(0);
        descripcion = "";
        precio = 0;
        contratoFirmado = false;
        numeroSecreto = 0;
        contratoGuardado = false;
    }

    function inicializarContrato(string memory _descripcion, uint256 _precio, uint256 _numeroSecreto) external {
        require(!contratoFirmado, "El contrato ya ha sido firmado");
        require(vendedor == address(0), "El contrato ya ha sido inicializado");
        require(msg.sender != address(0), "La direccion del vendedor no es valida");

        descripcion = _descripcion;
        precio = _precio;
        vendedor = msg.sender;
        numeroSecreto = _numeroSecreto;

        emit ContratoCreado(vendedor, descripcion, precio);
    }

    function firmarContrato(uint256 _numeroSecreto) external contratoNoFirmado {
        require(_numeroSecreto == numeroSecreto, "Numero secreto incorrecto");

        comprador = msg.sender;
        contratoFirmado = true;

        emit ContratoFirmado(comprador);
    }

    function guardarContratoEnBlockchain() external contratoFirmadoYNoGuardado {
        contratoGuardado = true;
        emit ContratoGuardado();
    }

    function verDetalleContrato() external view returns (string memory, uint256, address, address) {
        return (descripcion, precio, vendedor, comprador);
    }

    function obtenerEstadoContrato() external view returns (string memory) {
        if (!contratoFirmado) {
            return "Pendiente de firma";
        } else if (contratoFirmado && !contratoGuardado) {
            return "Firmado, pendiente de guardar";
        } else {
            return "Firmado y guardado";
        }
    }
}
