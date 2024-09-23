#!/bin/bash

# Função para gerar carga de CPU
cpu_stress() {
  echo "Gerando carga de CPU com stress..."
  stress --cpu 4 --timeout 60 &
}

# Função para gerar carga de memória
memory_stress() {
  echo "Gerando carga de memória com stress..."
  stress --vm 2 --vm-bytes 512M --timeout 60 &
}

# Função para gerar carga de disco com dd (gravação de arquivos grandes)
disk_stress() {
  echo "Gerando carga de disco com dd..."
  dd if=/dev/zero of=./stress_test_file bs=1M count=1024 oflag=direct &
}

# Função para gerar carga de I/O com stress
io_stress() {
  echo "Gerando carga de I/O com stress..."
  stress --io 2 --timeout 60 &
}

# Função para monitorar o uso de disco e I/O com iostat
monitor_io() {
  echo "Monitorando uso de I/O com iostat..."
  iostat -xz 2 5
}

# Função para gerar todas as cargas de uma vez
all_stress() {
  echo "Gerando todas as cargas de uma vez..."
  cpu_stress
  memory_stress
  disk_stress
  io_stress
  wait
  monitor_io
  # Limpa o arquivo gerado pelo dd
  rm -f ./stress_test_file
}

# Menu para a interface do usuário
show_menu() {
  echo "---------------------------"
  echo " Menu de Testes de Estresse "
  echo "---------------------------"
  echo "1) Gerar carga de CPU"
  echo "2) Gerar carga de Memória"
  echo "3) Gerar carga de Disco"
  echo "4) Gerar carga de I/O"
  echo "5) Gerar todas as cargas"
  echo "6) Sair"
  echo "Escolha uma opção:"
}

# Função principal para o menu
main() {
  while true; do
    show_menu
    read -p "Opção: " option
    case $option in
      1)
        cpu_stress
        wait
        ;;
      2)
        memory_stress
        wait
        ;;
      3)
        disk_stress
        wait
        # Limpa o arquivo gerado pelo dd
        rm -f ./stress_test_file
        ;;
      4)
        io_stress
        wait
        ;;
      5)
        all_stress
        ;;
      6)
        echo "Saindo..."
        break
        ;;
      *)
        echo "Opção inválida! Tente novamente."
        ;;
    esac
    echo "Teste concluído!"
    echo
  done
}

# Executa o script principal
main

