# Use uma imagem Nginx como base
FROM nginx:latest

# Copie todos os arquivos da pasta "app" para o diretório de conteúdo padrão do Nginx
COPY ./app/ /usr/share/nginx/html/

# Exponha a porta 80, que é a porta padrão do Nginx
EXPOSE 80

# Comando para iniciar o servidor Nginx
CMD ["nginx", "-g", "daemon off;"]
