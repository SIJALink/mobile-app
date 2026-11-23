
"use client";

import { useState } from "react";

type Dokumentasi = {
  id: number;
  judul: string;
  nama: string;
  lokasi: string;
  tanggal: string;
  waktu: string;
  jenis: "Foto" | "Video";
  keterangan: string;
  status: "Sudah Diperiksa" | "Belum Diperiksa";
  gambar: string;
};

const dataDokumentasi: Dokumentasi[] = [
  {
    id: 1,
    judul: "Pemeriksaan Area Utama",
    nama: "Andi Saputra",
    lokasi: "Area Utama",
    tanggal: "22 November 2026",
    waktu: "07:30",
    jenis: "Foto",
    keterangan: "Dokumentasi pemeriksaan kondisi area utama.",
    status: "Sudah Diperiksa",
    gambar: "https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800",
  },
  {
    id: 2,
    judul: "Kegiatan Piket Pagi",
    nama: "Budi Santoso",
    lokasi: "Area Timur",
    tanggal: "22 November 2026",
    waktu: "08:15",
    jenis: "Foto",
    keterangan: "Dokumentasi pelaksanaan kegiatan piket pagi.",
    status: "Belum Diperiksa",
    gambar: "https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=800",
  },
  {
    id: 3,
    judul: "Pengecekan Lingkungan",
    nama: "Dedi Kurniawan",
    lokasi: "Area Barat",
    tanggal: "21 November 2026",
    waktu: "09:00",
    jenis: "Foto",
    keterangan: "Dokumentasi pengecekan lingkungan sekitar.",
    status: "Sudah Diperiksa",
    gambar: "https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=800",
  },
  {
    id: 4,
    judul: "Laporan Kegiatan Piket",
    nama: "Rizky Pratama",
    lokasi: "Area Selatan",
    tanggal: "21 November 2026",
    waktu: "10:30",
    jenis: "Video",
    keterangan: "Video dokumentasi kegiatan Guru Piket.",
    status: "Belum Diperiksa",
    gambar: "https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800",
  },
];

export default function DokumentasiKepalaPage() {
  const [data, setData] = useState(dataDokumentasi);
  const [cari, setCari] = useState("");
  const [filterJenis, setFilterJenis] = useState("Semua");
  const [filterStatus, setFilterStatus] = useState("Semua");
  const [detail, setDetail] = useState<Dokumentasi | null>(null);

  const foto = data.filter((item) => item.jenis === "Foto").length;
  const video = data.filter((item) => item.jenis === "Video").length;
  const belum = data.filter(
    (item) => item.status === "Belum Diperiksa"
  ).length;

  const hasilFilter = data.filter((item) => {
    const cocokCari =
      item.judul.toLowerCase().includes(cari.toLowerCase()) ||
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.lokasi.toLowerCase().includes(cari.toLowerCase());

    const cocokJenis =
      filterJenis === "Semua" || item.jenis === filterJenis;

    const cocokStatus =
      filterStatus === "Semua" || item.status === filterStatus;

    return cocokCari && cocokJenis && cocokStatus;
  });

  function periksaDokumentasi(id: number) {
    setData((sebelumnya) =>
      sebelumnya.map((item) =>
        item.id === id
          ? { ...item, status: "Sudah Diperiksa" }
          : item
      )
    );

    setDetail(null);
  }

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Kepala SITE / Dokumentasi
          </p>

          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Dokumentasi Foto dan Video
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Lihat dan periksa dokumentasi kegiatan Guru Piket.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Dokumentasi</p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {data.length}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Seluruh dokumentasi
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Dokumentasi Foto</p>
            <h2 className="mt-3 text-3xl font-bold text-blue-600">
              {foto}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              File foto kegiatan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Dokumentasi Video</p>
            <h2 className="mt-3 text-3xl font-bold text-purple-600">
              {video}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              File video kegiatan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Belum Diperiksa</p>
            <h2 className="mt-3 text-3xl font-bold text-orange-500">
              {belum}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Menunggu pemeriksaan
            </p>
          </div>

        </div>

        {/* FILTER */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">

          <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Galeri Dokumentasi
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Dokumentasi kegiatan berdasarkan unggahan Guru Piket.
              </p>
            </div>

            <input
              type="text"
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              placeholder="Cari judul, nama, atau lokasi..."
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-80"
            />
          </div>

          <div className="mt-5 flex flex-wrap gap-3">
            <select
              value={filterJenis}
              onChange={(e) => setFilterJenis(e.target.value)}
              className="rounded-xl border border-slate-200 px-4 py-3 text-sm text-slate-600 outline-none"
            >
              <option value="Semua">Semua Jenis</option>
              <option value="Foto">Foto</option>
              <option value="Video">Video</option>
            </select>

            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="rounded-xl border border-slate-200 px-4 py-3 text-sm text-slate-600 outline-none"
            >
              <option value="Semua">Semua Status</option>
              <option value="Sudah Diperiksa">Sudah Diperiksa</option>
              <option value="Belum Diperiksa">Belum Diperiksa</option>
            </select>
          </div>

          {/* GALERI */}
          <div className="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">

            {hasilFilter.map((item) => (
              <div
                key={item.id}
                className="overflow-hidden rounded-2xl border border-slate-100 bg-white shadow-sm"
              >
                <div className="relative h-48 bg-slate-200">
                  <img
                    src={item.gambar}
                    alt={item.judul}
                    className="h-full w-full object-cover"
                  />

                  <span className="absolute left-3 top-3 rounded-lg bg-black/60 px-3 py-1 text-xs font-semibold text-white">
                    {item.jenis}
                  </span>
                </div>

                <div className="space-y-3 p-4">

                  <div>
                    <h3 className="font-bold text-slate-800">
                      {item.judul}
                    </h3>
                    <p className="mt-1 text-sm text-slate-500">
                      {item.nama}
                    </p>
                  </div>

                  <div className="space-y-1 text-xs text-slate-500">
                    <p>Lokasi: {item.lokasi}</p>
                    <p>Tanggal: {item.tanggal}</p>
                    <p>Waktu: {item.waktu}</p>
                  </div>

                  <div className="flex items-center justify-between gap-2">
                    <span
                      className={`rounded-full px-3 py-1 text-xs font-semibold ${
                        item.status === "Sudah Diperiksa"
                          ? "bg-green-100 text-green-700"
                          : "bg-orange-100 text-orange-700"
                      }`}
                    >
                      {item.status}
                    </span>

                    <button
                      onClick={() => setDetail(item)}
                      className="rounded-lg bg-blue-600 px-3 py-2 text-xs font-semibold text-white hover:bg-blue-700"
                    >
                      Lihat Detail
                    </button>
                  </div>

                </div>
              </div>
            ))}

            {hasilFilter.length === 0 && (
              <div className="col-span-full rounded-xl bg-slate-50 p-10 text-center text-sm text-slate-400">
                Dokumentasi tidak ditemukan.
              </div>
            )}

          </div>
        </section>

        {/* DETAIL MODAL */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/50 p-4">
            <div className="my-4 w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">

              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Dokumentasi
                </h2>

                <button
                  onClick={() => setDetail(null)}
                  className="text-2xl text-slate-400"
                >
                  ×
                </button>
              </div>

              <img
                src={detail.gambar}
                alt={detail.judul}
                className="mt-5 h-56 w-full rounded-xl bg-slate-100 object-cover"
              />

              <div className="mt-5 space-y-3 text-sm">
                <p>
                  <span className="text-slate-400">Judul: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.judul}
                  </span>
                </p>

                <p>
                  <span className="text-slate-400">Pengunggah: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.nama}
                  </span>
                </p>

                <p>
                  <span className="text-slate-400">Lokasi: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.lokasi}
                  </span>
                </p>

                <p>
                  <span className="text-slate-400">Tanggal: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.tanggal}, {detail.waktu}
                  </span>
                </p>

                <p>
                  <span className="text-slate-400">Jenis: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.jenis}
                  </span>
                </p>

                <p>
                  <span className="text-slate-400">Keterangan: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.keterangan}
                  </span>
                </p>

                <p>
                  <span className="text-slate-400">Status: </span>
                  <span className="font-semibold text-slate-800">
                    {detail.status}
                  </span>
                </p>
              </div>

              {detail.status === "Belum Diperiksa" && (
                <button
                  onClick={() => periksaDokumentasi(detail.id)}
                  className="mt-6 w-full rounded-xl bg-green-600 py-3 text-sm font-semibold text-white hover:bg-green-700"
                >
                  Tandai Sudah Diperiksa
                </button>
              )}

              <button
                onClick={() => setDetail(null)}
                className="mt-3 w-full rounded-xl bg-slate-100 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-200"
              >
                Tutup
              </button>

            </div>
          </div>
        )}

      </div>
    </main>
  );
}
