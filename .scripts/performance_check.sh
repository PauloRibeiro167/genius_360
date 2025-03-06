#!/bin/bash

echo "🔍 Verificando performance do sistema Genius360..."

echo -e "\n📊 Utilização de recursos dos containers:"
docker stats --no-stream

echo -e "\n🗄️ Estatísticas do PostgreSQL:"
docker-compose exec -T postgres psql -U postgres -d genius360_development -c "
SELECT 
  pg_size_pretty(pg_database_size('genius360_development')) as db_size,
  count(*) as total_tables 
FROM 
  information_schema.tables 
WHERE 
  table_schema='public';"

echo -e "\n🚀 Tempo de resposta da aplicação:"
time curl -s http://localhost:3000 > /dev/null

echo -e "\n📈 Processos no container web:"
docker-compose exec -T web ps aux --sort=-%mem | head -10

echo -e "\n✨ Verificação de performance concluída!"
