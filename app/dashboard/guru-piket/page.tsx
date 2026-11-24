
"use client";

import { useState } from "react";
import Link from "next/link";

type Jadwal = {
  id: number;
  nama: string;
  hari: string;
  tanggal: string;
  waktu: string;
  lokasi: string;
  status: string;
};

export default function GuruPiketPage() {
  const [jadwal, setJadwal] = useState<Jadwal[]>([
    {
      id: 1,
      nama: "Andi Saputra",
      hari: "Senin",
      tanggal: "2026-11-23",
      waktu: "07:00 - 12:00",
      lokasi: "Area Sekolah A",
      status: "Terjadwal",
    },
    {
      id: 2,
      nama: "Budi Santoso",
      hari: "Selasa",
      tanggal: "2026-11-24",
      waktu: "07:00 - 12:00",
      lokasi: "Area Sekolah B",
      status: "Berlangsung",
    },
    {
      id: 3,
      nama: "Dedi Kurniawan",
      hari: "Rabu",
      tanggal: "2026-11-25",
      waktu: "07:00 - 12:00",
      lokasi: "Area Sekolah A",
      status: "Selesai",
    },
  ]);

  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState<number | null>(null);

  const [form, setForm] = useState({
    nama: "",
    hari: "Senin",
    tanggal: "",
    waktu: "07:00 - 12:00",
    lokasi: "",
    status: "Terjadwal",
  });

  const total = jadwal.length;
  const terjadwal = jadwal.filter(
    (item) => item.status === "Terjadwal"
  ).length;
  const berlangsung = jadwal.filter(
    (item) => item.status === "Berlangsung"
  ).length;
  const selesai = jadwal.filter(
    (item) => item.status === "Selesai"
  ).length;

  const filteredJadwal = jadwal.filter((item) => {
    const cocokNama = item.nama
      .toLowerCase()
      .includes(search.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokNama && cocokStatus;
  });

  function bukaTambah() {
    setEditId(null);
    setForm({
      nama: "",
      hari: "Senin",
      tanggal: "",
      waktu: "07:00 - 12:00",
      lokasi: "",
      status: "Terjadwal",
    });
    setShowForm(true);
  }

  function bukaEdit(item: Jadwal) {
    setEditId(item.id);
    setForm({
      nama: item.nama,
      hari: item.hari,
      tanggal: item.tanggal,
      waktu: item.waktu,
      lokasi: item.lokasi,
      status: item.status,
    });
    setShowForm(true);
  }

  function simpanJadwal() {
    if (
      !form.nama.trim() ||
      !form.tanggal ||
      !form.lokasi.trim()
    ) {
      alert("Mohon lengkapi semua data!");
      return;
    }

    if (editId !== null) {
      setJadwal((data) =>
        data.map((item) =>
          item.id === editId
            ? { ...item, ...form }
            : item
        )
      );
    } else {
      const dataBaru: Jadwal = {
        id: Date.now(),
        ...form,
      };

      setJadwal((data) => [...data, dataBaru]);
    }

    setShowForm(false);
  }

  function hapusJadwal(id: number) {
    const yakin = confirm("Yakin ingin menghapus jadwal ini?");

    if (yakin) {
      setJadwal((data) =>
        data.filter((item) => item.id !== id)
      );
    }
  }

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl">

        {/* HEADER */}
        <div className="mb-8 flex flex-col justify-between gap-4 md:flex-row md:items-center">
          <div>
            <Link
              href="/dashboard"
              className="text-sm font-medium text-blue-600 hover:underline"
            >
              ← Kembali ke Dashboard
            </Link>

            <h1 className="mt-3 text-2xl font-bold text-slate-800 md:text-3xl">
              Penjadwalan Guru Piket
            </h1>

            <p className="mt-2 text-sm text-slate-500">
              Kelola dan atur jadwal kegiatan Guru Piket SIJALink.
            </p>
          </div>

          <button
            onClick={bukaTambah}
            className="rounded-xl bg-blue-700 px-5 py-3 font-semibold text-white shadow hover:bg-blue-800"
          >
            + Tambah Jadwal
          </button>
        </div>

        {/* STATISTIK */}
        <div className="mb-8 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <StatCard
            judul="Total Jadwal"
            angka={total}
            icon="📅"
            warna="bg-blue-600"
          />
          <StatCard
            judul="Terjadwal"
            angka={terjadwal}
            icon="📝"
            warna="bg-amber-500"
          />
          <StatCard
            judul="Berlangsung"
            angka={berlangsung}
            icon="⏳"
            warna="bg-sky-500"
          />
          <StatCard
            judul="Selesai"
            angka={selesai}
            icon="✓"
            warna="bg-emerald-600"
          />
        </div>

        {/* TABEL JADWAL */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">
          <div className="mb-6">
            <h2 className="text-xl font-bold text-slate-800">
              Daftar Jadwal Guru Piket
            </h2>
            <p className="mt-1 text-sm text-slate-500">
              Daftar petugas yang mendapatkan jadwal piket.
            </p>
          </div>

          <div className="mb-5 flex flex-col gap-3 md:flex-row">
            <input
              type="text"
              placeholder="Cari nama Guru Piket..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
            />

            <select
              value={filter}
              onChange={(e) => setFilter(e.target.value)}
              className="rounded-xl border border-slate-200 px-4 py-3 outline-none focus:border-blue-500"
            >
              <option value="Semua">Semua Status</option>
              <option value="Terjadwal">Terjadwal</option>
              <option value="Berlangsung">Berlangsung</option>
              <option value="Selesai">Selesai</option>
            </select>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead className="bg-slate-100 text-slate-600">
                <tr>
                  <th className="rounded-l-lg p-4">No</th>
                  <th className="p-4">Nama Guru</th>
                  <th className="p-4">Hari / Tanggal</th>
                  <th className="p-4">Waktu</th>
                  <th className="p-4">Lokasi</th>
                  <th className="p-4">Status</th>
                  <th className="rounded-r-lg p-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {filteredJadwal.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-b border-slate-100 hover:bg-slate-50"
                  >
                    <td className="p-4">{index + 1}</td>
                    <td className="p-4 font-semibold text-slate-800">
                      {item.nama}
                    </td>
                    <td className="p-4">
                      <div>{item.hari}</div>
                      <div className="text-xs text-slate-500">
                        {item.tanggal}
                      </div>
                    </td>
                    <td className="p-4">{item.waktu}</td>
                    <td className="p-4">{item.lokasi}</td>
                    <td className="p-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Selesai"
                            ? "bg-emerald-100 text-emerald-700"
                            : item.status === "Berlangsung"
                            ? "bg-sky-100 text-sky-700"
                            : "bg-amber-100 text-amber-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>
                    <td className="p-4">
                      <div className="flex gap-2">
                        <button
                          onClick={() => bukaEdit(item)}
                          className="rounded-lg bg-blue-100 px-3 py-2 text-blue-700 hover:bg-blue-200"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => hapusJadwal(item.id)}
                          className="rounded-lg bg-red-100 px-3 py-2 text-red-700 hover:bg-red-200"
                        >
                          Hapus
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}

                {filteredJadwal.length === 0 && (
                  <tr>
                    <td
                      colSpan={7}
                      className="p-8 text-center text-slate-500"
                    >
                      Jadwal Guru Piket tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* FORM TAMBAH / EDIT */}
        {showForm && (
          <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/50 p-4">
            <div className="my-auto w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">
              <h2 className="mb-5 text-xl font-bold text-slate-800">
                {editId !== null
                  ? "Edit Jadwal Guru Piket"
                  : "Tambah Jadwal Guru Piket"}
              </h2>

              <div className="space-y-4">
                <div>
                  <label className="mb-2 block text-sm font-medium">
                    Nama Guru Piket
                  </label>
                  <input
                    type="text"
                    value={form.nama}
                    onChange={(e) =>
                      setForm({ ...form, nama: e.target.value })
                    }
                    placeholder="Masukkan nama guru"
                    className="w-full rounded-xl border p-3 outline-none focus:border-blue-500"
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="mb-2 block text-sm font-medium">
                      Hari
                    </label>
                    <select
                      value={form.hari}
                      onChange={(e) =>
                        setForm({ ...form, hari: e.target.value })
                      }
                      className="w-full rounded-xl border p-3"
                    >
                      {[
                        "Senin",
                        "Selasa",
                        "Rabu",
                        "Kamis",
                        "Jumat",
                        "Sabtu",
                        "Minggu",
                      ].map((hari) => (
                        <option key={hari} value={hari}>
                          {hari}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label className="mb-2 block text-sm font-medium">
                      Tanggal
                    </label>
                    <input
                      type="date"
                      value={form.tanggal}
                      onChange={(e) =>
                        setForm({ ...form, tanggal: e.target.value })
                      }
                      className="w-full rounded-xl border p-3"
                    />
                  </div>
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium">
                    Waktu Piket
                  </label>
                  <input
                    type="text"
                    value={form.waktu}
                    onChange={(e) =>
                      setForm({ ...form, waktu: e.target.value })
                    }
                    placeholder="07:00 - 12:00"
                    className="w-full rounded-xl border p-3"
                  />
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium">
                    Lokasi Piket
                  </label>
                  <input
                    type="text"
                    value={form.lokasi}
                    onChange={(e) =>
                      setForm({ ...form, lokasi: e.target.value })
                    }
                    placeholder="Contoh: Area Sekolah A"
                    className="w-full rounded-xl border p-3"
                  />
                </div>

                <div>
                  <label className="mb-2 block text-sm font-medium">
                    Status
                  </label>
                  <select
                    value={form.status}
                    onChange={(e) =>
                      setForm({ ...form, status: e.target.value })
                    }
                    className="w-full rounded-xl border p-3"
                  >
                    <option>Terjadwal</option>
                    <option>Berlangsung</option>
                    <option>Selesai</option>
                  </select>
                </div>
              </div>

              <div className="mt-6 flex gap-3">
                <button
                  onClick={() => setShowForm(false)}
                  className="w-full rounded-xl border border-slate-300 py-3 font-semibold text-slate-600 hover:bg-slate-100"
                >
                  Batal
                </button>
                <button
                  onClick={simpanJadwal}
                  className="w-full rounded-xl bg-blue-700 py-3 font-semibold text-white hover:bg-blue-800"
                >
                  Simpan Jadwal
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </main>
  );
}

function StatCard({
  judul,
  angka,
  icon,
  warna,
}: {
  judul: string;
  angka: number;
  icon: string;
  warna: string;
}) {
  return (
    <div className="flex items-center gap-4 rounded-2xl bg-white p-5 shadow-sm">
      <div
        className={`flex h-14 w-14 items-center justify-center rounded-xl text-2xl text-white ${warna}`}
      >
        {icon}
      </div>
      <div>
        <p className="text-sm text-slate-500">{judul}</p>
        <h3 className="text-2xl font-bold text-slate-800">
          {angka}
        </h3>
      </div>
    </div>
  );
}
