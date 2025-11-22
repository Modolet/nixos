# 包覆盖配置
# 这里可以定义对 nixpkgs 中包的修改和覆盖

final: prev: {
  # 示例：覆盖某个包的配置
  # example = prev.example.override {
  #   enableFeature = true;
  # };

  # 示例：添加自定义补丁
  # another-example = prev.another-example.overrideAttrs (oldAttrs: {
  #   patches = (oldAttrs.patches or []) ++ [
  #     ./custom-patch.patch
  #   ];
  # });
}