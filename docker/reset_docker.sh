read -p "Docker(イメージ)を初期化しますか？ (y/n)" initialize < /dev/tty
case $initialize in
  y|Y) docker-compose down --rmi all || true ;;
esac

read -p "Docker(コンテナ・ボリューム)を初期化しますか？ (y/n)" initialize < /dev/tty
case $initialize in
  y|Y) docker-compose down --volume || true ;;
esac

read -p "リビルドしますか？ (y/n)" rebuild < /dev/tty
case $rebuild in
  y|Y) docker-compose build
       docker-compose run --rm app bundle exec rake db:reset
       docker-compose run -e RAILS_ENV=test --rm app bundle exec rake db:reset ;;
esac
