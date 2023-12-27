# node 버전 20.9를 베이스 이미지로 사용
FROM node:20.9.0 as builder

# 작업 디렉토리 설정
WORKDIR /app

# 현재 프로젝트의 package*.json을 app으로 복사
COPY package*.json ./

# 현재 프로젝트의 yarn.lock을 app으로 복사
COPY yarn.lock ./

# 의존성 설치
RUN yarn

# 현재 디렉토리의 모든 파일을 app으로 복사
COPY . .

# 프로젝트 빌드
RUN yarn run build

# nginx을 베이스 이미지로 사용
FROM nginx

# /app/dist를 nginx/html로 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# default conf 파일 제거
RUN rm /etc/nginx/conf.d/default.conf

# 내가 작성한 conf 파일을 nginx로 복사
COPY ./nginx.conf /etc/nginx/conf.d

# 80번 포트를 노출
EXPOSE 80

# nginx 백그라운드 실행
CMD ["nginx", "-g", "daemon off;"]