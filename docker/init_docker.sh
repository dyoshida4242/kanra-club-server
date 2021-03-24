set -e

echo "=== Starting docker-compose build... ==="

docker-compose build

echo "=== docker-compose build is complete! ==="

sleep 5
echo "=== Creating database of development and test ...==="

sleep 10 # wait to start the mysql container
docker-compose run --rm app bundle exec rake db:reset
docker-compose run -e RAILS_ENV=test --rm app bundle exec rake db:reset

echo "=== Creating database of development and test are complete! ==="

sleep 5
echo "=== Creating pid files  ...==="
mkdir -p tmp/pids/

echo "=== Pid files are created! ===
