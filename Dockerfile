#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /source
COPY ["src/AspNetCoreWithDocker/AspNetCoreWithDocker.csproj", "src/AspNetCoreWithDocker/"]
RUN dotnet restore "src/AspNetCoreWithDocker/AspNetCoreWithDocker.csproj"
COPY . .
RUN dotnet build "src/AspNetCoreWithDocker/AspNetCoreWithDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src/AspNetCoreWithDocker/AspNetCoreWithDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspNetCoreWithDocker.dll"]