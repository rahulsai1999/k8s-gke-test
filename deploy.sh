docker build -t noneuser2183/multi-client:latest -t noneuser2183/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t noneuser2183/multi-server:latest -t noneuser2183/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t noneuser2183/multi-worker:latest -t noneuser2183/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker
docker push noneuser2183/multi-client:latest
docker push noneuser2183/multi-server:latest
docker push noneuser2183/multi-worker:latest
docker push noneuser2183/multi-client:$GIT_SHA
docker push noneuser2183/multi-server:$GIT_SHA
docker push noneuser2183/multi-worker:$GIT_SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=noneuser2183/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=noneuser2183/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=noneuser2183/multi-worker:$GIT_SHA
