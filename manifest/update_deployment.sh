#!/bin/bash

# 파일 경로
deployment_file="manifest/02-deployment.yaml"

# 새로운 이미지 태그 값
new_image_tag="$ECR_REGISTRY/$ECR_REPOSITORY:${{ steps.build-image.outputs.imageTag }}"

# 파일 업데이트
while IFS= read -r line; do
  if [[ $line == *"image:"* ]]; then
    # 이미지 라인 찾기
    echo "    image: \"$new_image_tag\"" >> temp_deployment.yaml
  else
    echo "$line" >> temp_deployment.yaml
  fi
done < "$deployment_file"

# 임시 파일을 원래 파일로 복사
mv temp_deployment.yaml "$deployment_file"

# 커밋 및 푸시
git add "$deployment_file"
git commit -m "Update image tag to $new_image_tag"
git push origin main

