#!/bin/bash

# Gera carga de CPU, memória, disco e I/O usando stress, dd e iostat

# Função para gerar carga de CPU
cpu_stress() {
  echo "Gerando carga de CPU com stress..."
  # -c 4: usa 4 threads de CPU
  # -t 60s: roda por 60 segundos
  stress --cpu 4 --timeout 60 &
}

# Função para gerar carga de memória
memory_stress() {
  echo "Gerando carga de memória com stress..."
  # -m 2: usa 2 workers para alocar memória
  # --vm-bytes 512M: cada worker vai alocar 512MB
  stress --vm 2 --vm-bytes 512M --timeout 60 &
}

# Função para gerar carga de disco com dd (gravação de arquivos grandes)
disk_stress() {
  echo "Gerando carga de disco com dd..."
  # Grava um arquivo de 1GB no diretório atual
  dd if=/dev/zero of=./stress_test_file bs=1M count=1024 oflag=direct &
}

# Função para gerar carga de I/O com stress
io_stress() {
  echo "Gerando carga de I/O com stress..."
  # -i 2: gera 2 workers para carga de I/O
  stress --io 2 --timeout 60 &
}

# Função para monitorar o uso de disco e I/O com iostat
monitor_io() {
  echo "Monitorando uso de I/O com iostat..."
  # Mostra estatísticas de I/O a cada 2 segundos por 5 iterações
  iostat -xz 2 5
}

# Iniciando as cargas simultaneamente
cpu_stress
memory_stress
disk_stress
io_stress

# Espera todos os processos terminarem
wait

# Monitorar o I/O após os testes
monitor_io

# Limpa o arquivo gerado pelo dd para não ocupar espaço
rm -f ./stress_test_file

echo "Testes de carga concluídos."
